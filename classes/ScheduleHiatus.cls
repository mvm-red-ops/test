public with sharing class ScheduleHiatus {

	public static List<Schedules__c> hiatusDateRange(List<Schedules__c> schedules, Date startDate, Date endDate) {
		for(Schedules__c schedule : schedules) {
			// Handle cases where the schedule is already empty
			if(String.isEmpty(schedule.Days_Allowed__c)) {
				continue;
			}

			// Skip schedules that have already been canceled
			if(schedule.Status__c == 'Canceled') {
				continue;
			}

			// Handle cases where the schedule does not fall within the date range
			if(startDate > schedule.Week__c.addDays(6) || endDate < schedule.Week__c) {
				continue;
			}

			Set<String> daysAllowed = new Set<String>(schedule.Days_Allowed__c.split(';'));
			if(daysAllowed.contains('Mon') && startDate <= schedule.Week__c && endDate >= schedule.Week__c) {
				daysAllowed.remove('Mon');
			}
			if(daysAllowed.contains('Tue') && startDate <= schedule.Week__c.addDays(1) && endDate >= schedule.Week__c.addDays(1)) {
				daysAllowed.remove('Tue');
			}
			if(daysAllowed.contains('Wed') && startDate <= schedule.Week__c.addDays(2) && endDate >= schedule.Week__c.addDays(2)) {
				daysAllowed.remove('Wed');
			}
			if(daysAllowed.contains('Thu') && startDate <= schedule.Week__c.addDays(3) && endDate >= schedule.Week__c.addDays(3)) {
				daysAllowed.remove('Thu');
			}
			if(daysAllowed.contains('Fri') && startDate <= schedule.Week__c.addDays(4) && endDate >= schedule.Week__c.addDays(4)) {
				daysAllowed.remove('Fri');
			}
			if(daysAllowed.contains('Sat') && startDate <= schedule.Week__c.addDays(5) && endDate >= schedule.Week__c.addDays(5)) {
				daysAllowed.remove('Sat');
			}
			if(daysAllowed.contains('Sun') && startDate <= schedule.Week__c.addDays(6) && endDate >= schedule.Week__c.addDays(6)) {
				daysAllowed.remove('Sun');
			}

			if (daysAllowed.isEmpty()) {
				schedule.Status__c = 'Canceled';
			} else {
				schedule.Days_Allowed__c = String.join(new List<String>(daysAllowed), ';');
			}
		}

		return schedules;
	}

	public static List<Schedules__c> hiatusSingleDay(List<Schedules__c> schedules, Date selectedDate) {
		return hiatusDateRange(schedules, selectedDate, selectedDate);
	}

	public static List<Schedules__c> hiatusTimeAfter(List<Schedules__c> schedules, Date selectedDate, String timeEnd) {
		String selectedDay = Datetime.newInstance(selectedDate, Time.newInstance(0,0,0,0)).format('E');
		String selectedEndTime = Utils.civilianToMilitaryTime(timeEnd);

		List<Schedules__c> newSchedules = new List<Schedules__c>();

		for(Schedules__c schedule : schedules) {
			// Handle cases where the schedule is already empty
			if(String.isEmpty(schedule.Days_Allowed__c)) {
				continue;
			}

			// Skip schedules that have already been canceled
			if(schedule.Status__c == 'Canceled') {
				continue;
			}

			// Handle cases where the selected date does not fall within the schedule
			if(selectedDate > schedule.Week__c.addDays(6) || selectedDate < schedule.Week__c) {
				continue;
			}

			Set<String> daysAllowed = new Set<String>(schedule.Days_Allowed__c.split(';'));

			if(!daysAllowed.contains(selectedDay)) {
				continue;
			}

			String scheduleStartTime = Utils.civilianToMilitaryTime(schedule.Start_Time__c);
			String scheduleEndTime = Utils.civilianToMilitaryTime(schedule.End_Time__c);

			// Scenario 1: selected time is after the schedule's end time, do nothing
			if(isTimeBefore(scheduleEndTime, selectedEndTime)) {
				continue;
			} else if(isTimeBefore(selectedEndTime, scheduleStartTime)) {
				// Scenario 2: selected time is before the schedule's start time, remove that day of week from the schedule
				daysAllowed.remove(selectedDay);
			} else if((isTimeBefore(scheduleStartTime, selectedEndTime) || scheduleStartTime == '06:00')
					&& isTimeBefore(selectedEndTime, scheduleEndTime)) {
				// Scenario 3: selected time falls between the schedule's start and end time
				//	Clone schedule for this one day and remove day from original schedule if there are other days in the schedule
				if(daysAllowed.size() > 1) {
					daysAllowed.remove(selectedDay);

					Schedules__c newSchedule = schedule.clone(false, true);
					newSchedule.Days_Allowed__c = selectedDay;
					newSchedule.End_Time__c = timeEnd;
					newSchedule.Duplicate_Check__c = '';
					newSchedules.add(newSchedule);
				} else if(daysAllowed.size() == 1) {
					schedule.End_Time__c = timeEnd;
				}
			}

			if (daysAllowed.isEmpty()) {
				schedule.Status__c = 'Canceled';
			} else {
				schedule.Days_Allowed__c = String.join(new List<String>(daysAllowed), ';');
			}
		}

		if(!newSchedules.isEmpty()) {
			schedules.addAll(newSchedules);
		}

		return schedules;
	}

	public static List<Schedules__c> hiatusTimeBefore(List<Schedules__c> schedules, Date selectedDate, String timeStart) {
		String selectedDay = Datetime.newInstance(selectedDate, Time.newInstance(0,0,0,0)).format('E');
		String selectedStartTime = Utils.civilianToMilitaryTime(timeStart);

		List<Schedules__c> newSchedules = new List<Schedules__c>();

		for(Schedules__c schedule : schedules) {
			// Handle cases where the schedule is already empty
			if(String.isEmpty(schedule.Days_Allowed__c)) {
				continue;
			}

			// Skip schedules that have already been canceled
			if(schedule.Status__c == 'Canceled') {
				continue;
			}

			// Handle cases where the selected date does not fall within the schedule
			if(selectedDate > schedule.Week__c.addDays(6) || selectedDate < schedule.Week__c) {
				continue;
			}

			Set<String> daysAllowed = new Set<String>(schedule.Days_Allowed__c.split(';'));

			if(!daysAllowed.contains(selectedDay)) {
				continue;
			}

			String scheduleStartTime = Utils.civilianToMilitaryTime(schedule.Start_Time__c);
			String scheduleEndTime = Utils.civilianToMilitaryTime(schedule.End_Time__c);

			// Scenario 1: selected time is before the schedule's start time, do nothing
			if(scheduleStartTime != '06:00' && isTimeBefore(selectedStartTime, scheduleStartTime)) {
				continue;
			} else if(isTimeBefore(scheduleEndTime, selectedStartTime)) {
				// Scenario 2: selected time is after the schedule's end time, remove that day of week from the schedule
				daysAllowed.remove(selectedDay);
			} else if((isTimeBefore(scheduleStartTime, selectedStartTime) || scheduleStartTime == '06:00')
					&& isTimeBefore(selectedStartTime, scheduleEndTime)) {
				// Scenario 3: selected time falls between the schedule's start and end time
				//	Clone schedule for this one day and remove day from original schedule if there are other days in the schedule
				if(daysAllowed.size() > 1) {
					daysAllowed.remove(selectedDay);

					Schedules__c newSchedule = schedule.clone(false, true);
					newSchedule.Days_Allowed__c = selectedDay;
					newSchedule.Start_Time__c = timeStart;
					newSchedule.Duplicate_Check__c = '';
					newSchedules.add(newSchedule);
				} else if(daysAllowed.size() == 1) {
					schedule.Start_Time__c = timeStart;
				}
			}

			if (daysAllowed.isEmpty()) {
				schedule.Status__c = 'Canceled';
			} else {
				schedule.Days_Allowed__c = String.join(new List<String>(daysAllowed), ';');
			}
		}

		if(!newSchedules.isEmpty()) {
			schedules.addAll(newSchedules);
		}

		return schedules;
	}

	public static Boolean isTimeBefore(String militaryTime1, String militaryTime2) {
		// Convert '12:00' to integer 1200
		Integer time1 = Integer.valueOf(militaryTime1.remove(':'));
		Integer time2 = Integer.valueOf(militaryTime2.remove(':'));

		// In this case, a day is from 6:00A to 6:00A the next day, need to account for that
		//	so that 5:00 is considered LATER in the day than 23:00
		if(time1 <= 600) {
			time1 += 2400;
		}
		if(time2 <= 600) {
			time2 += 2400;
		}
		return time1 <= time2;
	}
}