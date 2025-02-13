//
//  AnnounceAlarmSettingViewModel.swift
//  Studing
//
//  Created by ParkJunHyuk on 2/6/25.
//

import Combine
import Foundation

enum AlarmState {
    case selected
    case unSelected
    
    var mainTitle: String {
        switch self {
        case .selected:
            return "리마인드 알림 취소"
            
        case .unSelected:
            return "알림 설정"
        }
    }
    
    var subTitle: String {
        switch self {
        case .selected:
            return "해당 공지사항에 설정한\n푸쉬 알림을 취소하시겠습니까?"
            
        case .unSelected:
            return "리마인드 푸쉬 알림을 받고 싶은\n날짜와 시간을 설정해주세요!"
        }
    }
}

final class AnnounceAlarmSettingViewModel {
    
    // MARK: - Private properties
    
    private(set) var noticeId: Int?
    
    // MARK: - Combine Publishers Properties
    
    var alarmStateSubject: CurrentValueSubject<AlarmState, Never>
    let alarmDaySubject = CurrentValueSubject<DateComponents, Never>(Calendar.current.dateComponents([.year, .month, .day], from: Date()))
    let alarmTimeSubject = CurrentValueSubject<DateComponents, Never>(Calendar.current.dateComponents([.hour, .minute], from: Date()))
    
    // MARK: - UseCase properties
    
    private var registAlarmNoticeUseCase: AlarmNoticeUseCase?
    private var deleteAlarmNoticeUseCase: DeleteAlarmNoticeUseCase?
    
    // MARK: - Init
    
    init(
        noticeId: Int,
        alarmData: AlarmSettingData,
        registAlarmNoticeUseCase: AlarmNoticeUseCase? = nil,
        deleteAlarmNoticeUseCase: DeleteAlarmNoticeUseCase? = nil
    ) {
        print("AnnounceAlarmSettingViewModel init")
        
        self.noticeId = noticeId
        self.alarmStateSubject = CurrentValueSubject<AlarmState, Never>(alarmData.isAlarm ? .selected : .unSelected)
        
        switch alarmData.isAlarm {
        case true:
            guard let day = alarmData.alarmDay, let time = alarmData.alarmTime else { return }
            self.alarmDaySubject.send(day)
            self.alarmTimeSubject.send(time)
            self.deleteAlarmNoticeUseCase = RemoveAlarmNoticeUseCase(repository: NotificationsRepositoryImpl())
            
        case false:
            self.registAlarmNoticeUseCase = AlarmNoticeUseCase(repository: NotificationsRepositoryImpl())
        }
    }
    
    deinit {
        print("AnnounceAlarmSettingViewModel deinit")
    }
    
    // MARK: - Input
    
    struct Input {
        let confirmButtonTap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let alarmStateResult: AnyPublisher<AlarmState, Never>
        let confirmButtonResult: AnyPublisher<Bool, NetworkError>
        let alarmDayResult: AnyPublisher<String, Never>
        let alarmTimeResult: AnyPublisher<String, Never>
    }
    
    // MARK: - Public methods
    
    func transform(input: Input) -> Output {
        let confirmButtonResult = input.confirmButtonTap
            .flatMap { _ -> AnyPublisher<Bool, NetworkError> in
                switch self.alarmStateSubject.value {
                case .selected:
                    return self.deleteAlarmNoticePublisher()
                        .eraseToAnyPublisher()
                    
                case .unSelected:
                    return self.postAlarmNoticePublisher()
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
        
        let alarmDayResult = alarmDaySubject
            .map { startDay -> String in
                return self.formatDay(startDay)
            }
            .eraseToAnyPublisher()
            
        let alarmTimeResult = alarmTimeSubject
            .map { startTime -> String in
                return self.formatTime(startTime)
            }
            .eraseToAnyPublisher()
        
        return Output(
            alarmStateResult: alarmStateSubject.eraseToAnyPublisher(),
            confirmButtonResult: confirmButtonResult,
            alarmDayResult: alarmDayResult,
            alarmTimeResult: alarmTimeResult
        )
    }
}

// MARK: - Public API methods

extension AnnounceAlarmSettingViewModel {
    func postAlarmNoticePublisher() -> AnyPublisher<Bool, NetworkError> {
        
        guard let noticeId, let useCase = registAlarmNoticeUseCase else {
            return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
        }
        
        return Future { [weak self] promise in
            guard let self else {
                    promise(.failure(.unknown)) // self가 nil이면 실패 처리
                    return
                }
            
            guard let year = alarmDaySubject.value.year,
                  let month = alarmDaySubject.value.month,
                  let day = alarmDaySubject.value.day,
                  let hour = alarmTimeSubject.value.hour,
                  let minute = alarmTimeSubject.value.minute else {
                return promise(.failure(.unknown))
            }
            
            print(year, month, day, hour, minute)

            Task {
                do {
                    let _ = try await useCase.execute(noticeId: noticeId, dto: AlarmNoticeRequestDTO(year: year, month: month, day: day, hour: hour, minute: minute))
                    
                    promise(.success(true))
                } catch let error as NetworkError {
                    promise(.failure(error))
                } catch {
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    
    func deleteAlarmNoticePublisher() -> AnyPublisher<Bool, NetworkError> {
        
        guard let noticeId, let useCase = deleteAlarmNoticeUseCase else {
            return Fail(error: NetworkError.unknown).eraseToAnyPublisher()
        }
        
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let _ = try await useCase.execute(noticeId: noticeId)
                    
                    promise(.success(true))
                    
                } catch let error as NetworkError {
                    promise(.failure(error))
                    
                } catch {
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension AnnounceAlarmSettingViewModel {
    func formatTime(_ dateComponents: DateComponents) -> String {
        
        guard let hour = dateComponents.hour,
              let minute = dateComponents.minute else { return "" }
        
        let timeString = String(format: "%02d:%02d", hour, minute)
        
        return timeString
    }
    
    func formatDay(_ dateComponents: DateComponents) -> String {
        
        guard let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day else { return "" }
        
        let dateString = String(format: "%d년 %d월 %d일", year, month, day)
        
        return dateString
    }
}
