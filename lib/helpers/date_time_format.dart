String convertMinute(String minute) {
  if (minute.length == 1) {
    switch (minute) {
      case '0':
        minute = '00';
        break;
      case '1':
        minute = '01';
        break;
      case '2':
        minute = '02';
        break;
      case '3':
        minute = '03';
        break;
      case '4':
        minute = '04';
        break;
      case '5':
        minute = '05';
        break;
      case '6':
        minute = '06';
        break;
      case '7':
        minute = '07';
        break;
      case '8':
        minute == '08';
        break;
      case '9':
        minute = '09';
        break;
    }
  }
  return minute;
}

String convertMonth(int month) {
  String monthName;
  switch (month) {
    case 1:
      monthName = 'Январь';
      break;
    case 2:
      monthName = 'Февраль';
      break;
    case 3:
      monthName = 'Март';
      break;
    case 4:
      monthName = 'Апрель';
      break;
    case 5:
      monthName = 'Май';
      break;
    case 6:
      monthName = 'Июнь';
      break;
    case 7:
      monthName = 'Июль';
      break;
    case 8:
      monthName = 'Август';
      break;
    case 9:
      monthName = 'Сентябрь';
      break;
    case 10:
      monthName = 'Октябрь';
      break;
    case 11:
      monthName = 'Нояборь';
      break;
    case 12:
      monthName = 'Декабрь';
      break;
  }

  return monthName;
}
