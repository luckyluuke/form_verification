import 'dart:async';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_verification/NotificationApi.dart';
import 'package:form_verification/UserManager.dart';
import 'package:form_verification/database.dart';
import 'package:form_verification/enums.dart';

class HelperFormPage extends StatefulWidget {
  @override
  _HelperFormPageState createState() => _HelperFormPageState();
}


class _HelperFormPageState extends State<HelperFormPage> {

  final ScrollController _scrollController = ScrollController();

  Map<String,dynamic> daysScheduledLives ={
    'Monday':[],
    'Tuesday':[],
    'Wednesday':[],
    'Thursday':[],
    'Friday':[],
    'Saturday':[],
    'Sunday':[],
  };

  Map<String,Map<int,dynamic>> allIndexesDataForCanDelete = {
    'Monday': {},
    'Tuesday':{},
    'Wednesday':{},
    'Thursday':{},
    'Friday':{},
    'Saturday':{},
    'Sunday':{},

  };

  Map<String,Map<int,dynamic>> allIndexesDataForCannotDeleteWithExistingUser = {
    'Monday': {},
    'Tuesday':{},
    'Wednesday':{},
    'Thursday':{},
    'Friday':{},
    'Saturday':{},
    'Sunday':{},
  };

  Map<String,Map<String,dynamic>> allLivesButtonsParams = {
    'Monday': {},
    'Tuesday':{},
    'Wednesday':{},
    'Thursday':{},
    'Friday':{},
    'Saturday':{},
    'Sunday':{},
  };


  Map<String,dynamic> finalDaysScheduledLives = {};

  static const List<String> listOfDays = ["lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche"];

  DocumentReference ? _usersRef;
  StreamSubscription? _subscription;

  bool isLoading = false;
  bool secondPage = false;
  bool thirdPage = false;
  bool isHelper = false;
  bool helperScheduledLivesAlreadyCreated = false;
  bool liveScheduledButtonValidated = false;
  String? _selectedDay;
  String? first_name = "";
  UserManager _userManager = UserManager();
  Map<String, dynamic> data = {};
  List customAddedKeyWords = [];
  late TextEditingController myTextLastnameController = TextEditingController();
  late TextEditingController myTextFirstnameController = TextEditingController();
  late TextEditingController myPresentationController = TextEditingController();
  //DAYS
  bool isMondayWellConfigured = false;
  bool isTuesdayWellConfigured = false;
  bool isWednesdayWellConfigured = false;
  bool isThursdayWellConfigured = false;
  bool isFridayWellConfigured = false;
  bool isSaturdayWellConfigured = false;
  bool isSundayWellConfigured = false;
  bool helperIsUnavailableOnMonday = false;
  bool helperIsUnavailableOnTuesday = false;
  bool helperIsUnavailableOnWednesday = false;
  bool helperIsUnavailableOnThursday = false;
  bool helperIsUnavailableOnFriday = false;
  bool helperIsUnavailableOnSaturday = false;
  bool helperIsUnavailableOnSunday = false;

  //SCHEDULED HOURS
  bool eight_to_nine = false;
  bool nine_to_ten = false;
  bool ten_to_eleven = false;
  bool eleven_to_twelve = false;
  bool twelve_to_thirteen = false;
  bool thirteen_to_fourteen = false;
  bool fourteen_to_fifteen = false;
  bool fifteen_to_sixteen = false;
  bool sixteen_to_seventeen = false;
  bool seventeen_to_eighteen = false;
  bool eighteen_to_nineteen = false;
  bool nineteen_to_twenty = false;
  bool twenty_to_twentyOne= false;
  bool twentyOne_to_twentyTwo = false;
  bool twentyTwo_to_twentyThree = false;
  bool twentyThree_to_midnight = false;
  bool midnight_to_one = false;
  bool one_to_two = false;
  bool two_to_three = false;
  bool three_to_four = false;
  bool four_to_five = false;
  bool five_to_six = false;
  bool six_to_seven = false;
  bool seven_to_eight = false;

  //LEVELS
  bool primaryLevelState = false;
  bool collegeLevelState = false;
  bool highSchoolLevelState = false;
  bool classePreparatoireLevelState = false;
  bool butDutLevelState = false;
  bool btsLevelState = false;
  bool engineeringLevelState = false;
  bool architectLevelState = false;
  bool commercialLevelState = false;
  bool medicalLevelState = false;
  bool artisticLevelState = false;
  bool otherLevelState = false;

  //CLASSES
  bool primaryLevelState_cp = true;
  bool primaryLevelState_ce1 = true;
  bool primaryLevelState_ce2 = true;
  bool primaryLevelState_cm1 = true;
  bool primaryLevelState_cm2 = true;

  bool collegeLevelState_sixth = true;
  bool collegeLevelState_fifth = true;
  bool collegeLevelState_fourth = true;
  bool collegeLevelState_third = true;

  bool highSchoolLevelState_second = true;
  bool highSchoolLevelState_first = true;
  bool highSchoolLevelState_terminal = true;

  bool classePreparatoireLevelState_first_year = true;
  bool classePreparatoireLevelState_second_year = true;

  bool butDutLevelState_first_year = true;
  bool butDutLevelState_second_year = true;
  bool butDutLevelState_third_year = true;

  bool btsLevelState_first_year = true;
  bool btsLevelState_second_year = true;

  bool engineeringLevelState_first_year = true;
  bool engineeringLevelState_second_year = true;
  bool engineeringLevelState_third_year = true;

  bool architectLevelState_first_year = true;
  bool architectLevelState_second_year = true;
  bool architectLevelState_third_year = true;
  bool architectLevelState_fourth_year = true;
  bool architectLevelState_fifth_year = true;

  bool commercialLevelState_first_year = true;
  bool commercialLevelState_second_year = true;
  bool commercialLevelState_third_year = true;
  bool commercialLevelState_fourth_year = true;
  bool commercialLevelState_fifth_year = true;


  bool medicalLevelState_first_cycle = true;
  bool medicalLevelState_second_cycle = true;
  bool medicalLevelState_third_cycle = true;


  bool artisticLevelState_graphics = true;
  bool artisticLevelState_music = true;
  bool artisticLevelState_animation = true;
  bool artisticLevelState_design = true;
  bool artisticLevelState_audiovisual = true;
  bool artisticLevelState_cinema = true;
  bool artisticLevelState_luxury = true;
  bool artisticLevelState_mode = true;
  bool artisticLevelState_visual_communication = true;
  bool artisticLevelState_multimedia = true;
  bool artisticLevelState_theater = true;
  bool artisticLevelState_arts = true;







  //SUBJECTS
  bool primarySubjectState_maths = false;
  bool primarySubjectState_physics = false;
  bool primarySubjectState_chemistry = false;
  bool primarySubjectState_french = false;
  bool primarySubjectState_history = false;
  bool primarySubjectState_geography = false;
  bool primarySubjectState_english = false;
  bool primarySubjectState_spanish = false;
  bool primarySubjectState_svt = false;
  bool primarySubjectState_technology = false;
  bool primarySubjectState_german = false;
  bool primarySubjectState_philosophy = false;
  bool primarySubjectState_literature = false;
  bool primarySubjectState_ses = false;
  bool primarySubjectState_latin = false;
  bool primarySubjectState_biology = false;
  bool primarySubjectState_si = false;
  bool primarySubjectState_arts = false;
  bool primarySubjectState_italian = false;
  bool primarySubjectState_arab = false;
  bool primarySubjectState_chinese = false;
  bool primarySubjectState_hebrew = false;
  bool primarySubjectState_portuguese = false;
  bool primarySubjectState_russian = false;
  bool primarySubjectState_japanese = false;
  bool primarySubjectState_dutch = false;

  bool secondarySubjectState_programming = false;
  bool secondarySubjectState_communication = false;
  bool secondarySubjectState_chemistry = false;
  bool secondarySubjectState_genius_civil= false;
  bool secondarySubjectState_genius_mechanic = false;
  bool secondarySubjectState_genius_thermal = false;
  bool secondarySubjectState_genius_industrial = false;
  bool secondarySubjectState_genius_chemistry = false;
  bool secondarySubjectState_genius_biologic = false;
  bool secondarySubjectState_genius_programming = false;
  bool secondarySubjectState_administration_management = false;
  bool secondarySubjectState_companies_management = false;
  bool secondarySubjectState_telecoms_network = false;
  bool secondarySubjectState_legal_careers = false;
  bool secondarySubjectState_social_careers = false;
  bool secondarySubjectState_physics_measures = false;

  bool secondarySubjectState_design = false;
  bool secondarySubjectState_audiovisual = false;
  bool secondarySubjectState_insurance = false;
  bool secondarySubjectState_bank = false;
  bool secondarySubjectState_management = false;
  bool secondarySubjectState_sale = false;
  bool secondarySubjectState_accounting = false;
  bool secondarySubjectState_building = false;
  bool secondarySubjectState_public_works = false;
  bool secondarySubjectState_electronic = false;
  bool secondarySubjectState_electrical_engineering = false;
  bool secondarySubjectState_hotel = false;
  bool secondarySubjectState_restaurant = false;
  bool secondarySubjectState_tourism = false;
  bool secondarySubjectState_mechanic = false;
  bool secondarySubjectState_automatism = false;
  bool secondarySubjectState_metallic_constructions = false;
  bool secondarySubjectState_health = false;
  bool secondarySubjectState_paramedic = false;
  bool secondarySubjectState_social = false;

  bool secondarySubjectState_marketing = false;
  bool secondarySubjectState_financial_management = false;
  bool secondarySubjectState_energy = false;
  bool secondarySubjectState_economy = false;
  bool secondarySubjectState_human_sciences = false;

  bool secondarySubjectState_space_geometry = false;
  bool secondarySubjectState_law = false;
  bool secondarySubjectState_sociology = false;
  bool secondarySubjectState_material_resistance = false;
  bool secondarySubjectState_acoustic = false;
  bool secondarySubjectState_road = false;
  bool secondarySubjectState_architecture_history = false;

  bool secondarySubjectState_office_automation = false;
  bool secondarySubjectState_project_management = false;
  bool secondarySubjectState_finance = false;
  bool secondarySubjectState_taxation = false;
  bool secondarySubjectState_human_resources = false;
  bool secondarySubjectState_statistics = false;

  bool secondarySubjectState_medical_specialities = false;
  bool secondarySubjectState_work_medicine = false;
  bool secondarySubjectState_public_health = false;
  bool secondarySubjectState_surgical_specialities = false;
  bool secondarySubjectState_medical_biology = false;
  bool secondarySubjectState_psychiatry = false;
  bool secondarySubjectState_gynecologist = false;
  bool secondarySubjectState_obstetrics_pediatrics = false;
  bool secondarySubjectState_anesthesiology = false;
  bool secondarySubjectState_surgical_resuscitation = false;
  bool secondarySubjectState_general_medicine = false;

  //TODO:Best way of registering keywords (useful with queries)
  List listOfKeyWords = [];


  List<String> listOfMondayLives = [];
  List<String> listOfTuesdayLives = [];
  List<String> listOfWednesdayLives = [];
  List<String> listOfThursdayLives = [];
  List<String> listOfFridayLives = [];
  List<String> listOfSaturdayLives = [];
  List<String> listOfSundayLives = [];


  _HelperFormPageState(){
    _selectedDay = "lundi";
    _usersRef = FirebaseFirestore.instance.collection('allUsers').doc(_userManager.userId);
    _subscription = _usersRef!.snapshots().listen( (snapshot){
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null){
        setState(() {
          isHelper = data['is_helper'];
        });
      }
    }
    );
    initParams();
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  bool continueProcessOrNot(String currentSelectedDay){
    return true;//(daysScheduledLives[CommonFunctionsManager.getDayTranslation(currentSelectedDay)].isEmpty && !checkDayAvailability(currentSelectedDay));
  }

  void checkDayConfig(String day){
    //for(String day in listOfDays){
      if (!continueProcessOrNot(day)){
        enableDayConfig(day);
      }
    //}
  }

  bool isDayConfigDone(String day){

    bool configStatus = false;

    switch(day) {
      case "lundi":
        {
          configStatus = isMondayWellConfigured;
        }
        break;
      case "mardi":
        {
          configStatus = isTuesdayWellConfigured;
        }
        break;
      case "mercredi":
        {
          configStatus = isWednesdayWellConfigured;
        }
        break;
      case "jeudi":
        {
          configStatus = isThursdayWellConfigured;
        }
        break;
      case "vendredi":
        {
          configStatus = isFridayWellConfigured;
        }
        break;
      case "samedi":
        {
          configStatus = isSaturdayWellConfigured;
        }
        break;
      case "dimanche":
        {
          configStatus = isSundayWellConfigured;
        }
        break;
      }

      return configStatus;
    }

  void enableDayConfig(String day){

    switch(day) {
      case "lundi":
        {
          isMondayWellConfigured = true;
        }
        break;
      case "mardi":
        {
          isTuesdayWellConfigured = true;
        }
        break;
      case "mercredi":
        {
          isWednesdayWellConfigured = true;
        }
        break;
      case "jeudi":
        {
          isThursdayWellConfigured = true;
        }
        break;
      case "vendredi":
        {
          isFridayWellConfigured = true;
        }
        break;
      case "samedi":
        {
          isSaturdayWellConfigured= true;
        }
        break;
      case "dimanche":
        {
          isSundayWellConfigured = true;
        }
        break;
    }
  }

  void resetLiveTimes(){
    eight_to_nine = false;
    nine_to_ten = false;
    ten_to_eleven = false;
    eleven_to_twelve = false;
    twelve_to_thirteen = false;
    thirteen_to_fourteen = false;
    fourteen_to_fifteen = false;
    fifteen_to_sixteen = false;
    sixteen_to_seventeen = false;
    seventeen_to_eighteen = false;
    eighteen_to_nineteen = false;
    nineteen_to_twenty = false;
    twenty_to_twentyOne= false;
    twentyOne_to_twentyTwo = false;
    twentyTwo_to_twentyThree = false;
    twentyThree_to_midnight = false;
    midnight_to_one = false;
    one_to_two = false;
    two_to_three = false;
    three_to_four = false;
    four_to_five = false;
    five_to_six = false;
    six_to_seven = false;
    seven_to_eight = false;
    liveScheduledButtonValidated = false;
  }

  void initParams() async {

    var tmpMap = await _userManager.getResult("allScheduledLives", _userManager.userId!);

    tmpMap.forEach((key, value) {
      value.forEach((element) {
        String time = element.split("|").elementAt(0);
        String cannotDeleteStatus = element.split("|").elementAt(1);
        String? userId = element.split("|").elementAt(2);
        String? temporaryPayload;

        if (userId != null && userId.isNotEmpty){
          temporaryPayload = cannotDeleteStatus + "|" + userId;
        }
        else
        {
          temporaryPayload =  cannotDeleteStatus;
        }

        daysScheduledLives[key].add(g_scheduledLives.indexOf(time));

        //TODO: ZAMBA, must not delete spot if a user is scheduled
        /*if((userId != null) && (userId.isNotEmpty)){
          allLivesButtonsParams[key]![time] = true;
          allIndexesDataForCannotDeleteWithExistingUser[key]![g_scheduledLives.indexOf(time)] = temporaryPayload;
        }else{
          allIndexesDataForCanDelete[key]![g_scheduledLives.indexOf(time)] = temporaryPayload;
        }*/

        if("cannotDelete" == cannotDeleteStatus){
          allLivesButtonsParams[key]![time] = true;

          if(userId!.isNotEmpty){
            allIndexesDataForCannotDeleteWithExistingUser[key]![g_scheduledLives.indexOf(time)] = temporaryPayload;
          }
        }
        else
        {
          allIndexesDataForCanDelete[key]![g_scheduledLives.indexOf(time)] = temporaryPayload;
        }

      });

    });

    /*allLivesButtonsParams[CommonFunctionsManager.getDayTranslation(_selectedDay!)]!.forEach((key, value) {
      setParam(key, value);
    });*/

  }

  String getFinalScheduledLivesStatus(){
    String result = "SUCCESS";

    for(String day in listOfDays){
      if (continueProcessOrNot(day)){
        result = "Tu n'as pas défini ta journée de " + day.toUpperCase();
        break;
      }
    }
    return result;
  }

  bool checkDayAvailability (String day){
    bool status = false;
    switch(day) {
      case "lundi":
        {
          status = helperIsUnavailableOnMonday;
        }
        break;
      case "mardi":
        {
          status = helperIsUnavailableOnTuesday;
        }
        break;
      case "mercredi":
        {
          status = helperIsUnavailableOnWednesday;
        }
        break;
      case "jeudi":
        {
          status = helperIsUnavailableOnThursday;
        }
        break;
      case "vendredi":
        {
          status = helperIsUnavailableOnFriday;
        }
        break;
      case "samedi":
        {
          status = helperIsUnavailableOnSaturday;
        }
        break;
      case "dimanche":
        {
          status = helperIsUnavailableOnSunday;
        }
        break;
    }
    return status;
  }

  void setDayAvailability(String currentDaySelected){

    switch(currentDaySelected) {
      case "lundi":
        {
          helperIsUnavailableOnMonday = !helperIsUnavailableOnMonday;
        }
        break;
      case "mardi":
        {
          helperIsUnavailableOnTuesday = !helperIsUnavailableOnTuesday;
        }
        break;
      case "mercredi":
        {
          helperIsUnavailableOnWednesday = !helperIsUnavailableOnWednesday;
        }
        break;
      case "jeudi":
        {
          helperIsUnavailableOnThursday = !helperIsUnavailableOnThursday;
        }
        break;
      case "vendredi":
        {
          helperIsUnavailableOnFriday = !helperIsUnavailableOnFriday;
        }
        break;
      case "samedi":
        {
          helperIsUnavailableOnSaturday = !helperIsUnavailableOnSaturday;
        }
        break;
      case "dimanche":
        {
          helperIsUnavailableOnSunday = !helperIsUnavailableOnSunday;
        }
        break;
    }
  }

  void sortScheduledDaysLives(){
    daysScheduledLives.entries.forEach((day) {
      List allScheduledTime = day.value;
      allScheduledTime.sort();
      List newList = [];
      allScheduledTime.forEach((element)
      {

        String payload = "";

        if(allIndexesDataForCannotDeleteWithExistingUser[day.key]!.keys.contains(element)){

          payload = "|" + allIndexesDataForCannotDeleteWithExistingUser[day.key]![element] + "|" ;

        } else if (allIndexesDataForCanDelete[day.key]!.keys.contains(element)){

          if(
          true
          /*allLivesButtonsParams[CommonFunctionsManager.getDayTranslation(_selectedDay!)]!.keys.contains(g_scheduledLives.elementAt(element))
          && allLivesButtonsParams[CommonFunctionsManager.getDayTranslation(_selectedDay!)]![g_scheduledLives.elementAt(element)]*/
          ){
            List tmpList = allIndexesDataForCanDelete[day.key]![element].split("|");

            if (tmpList.length == 2){
              payload = "|cannotDelete|" + tmpList.elementAt(1) + "|";
            }
            else
            {
              payload = "|cannotDelete|";
            }
          }
          else
          {
            payload = "|" + allIndexesDataForCanDelete[day.key]![element] + "|";
          }

        }else {
          payload = "|cannotDelete|";
        }

        newList.add(g_scheduledLives.elementAt(element) + payload);

      });

      finalDaysScheduledLives[day.key] = newList;
    });
  }

  bool getParam(String time){
    bool result = false;

    switch(time) {
      case ScheduledTime.EIGHT_TO_NINE:
        {
          result = eight_to_nine;
        }
        break;
      case ScheduledTime.NINE_TO_TEN:
        {
          result = nine_to_ten;
        }
        break;
      case ScheduledTime.TEN_TO_ELEVEN:
        {
          result = ten_to_eleven;
        }
        break;
      case ScheduledTime.ELEVEN_TO_TWELVE:
        {
          result = eleven_to_twelve;
        }
        break;
      case ScheduledTime.TWELVE_TO_THIRTEEN:
        {
          result = twelve_to_thirteen;
        }
        break;
      case ScheduledTime.THIRTEEN_TO_FOURTEEN:
        {
          result = thirteen_to_fourteen;
        }
        break;
      case ScheduledTime.FOURTEEN_TO_FIFTEEN:
        {
          result = fourteen_to_fifteen;
        }
        break;
      case ScheduledTime.FIFTEEN_TO_SIXTEEN:
        {
          result = fifteen_to_sixteen;
        }
        break;
      case ScheduledTime.SIXTEEN_TO_SEVENTEEN:
        {
          result = sixteen_to_seventeen;
        }
        break;
      case ScheduledTime.SEVENTEEN_TO_EIGHTEEN:
        {
          result = seventeen_to_eighteen;
        }
        break;
      case ScheduledTime.EIGHTEEN_TO_NINETEEN:
        {
          result = eighteen_to_nineteen;
        }
        break;
      case ScheduledTime.NINETEEN_TO_TWENTY:
        {
          result = nineteen_to_twenty;
        }
        break;
      case ScheduledTime.TWENTY_TO_TWENTY_ONE:
        {
          result = twenty_to_twentyOne;
        }
        break;
      case ScheduledTime.TWENTY_ONE_TO_TWENTY_TWO:
        {
          result = twentyOne_to_twentyTwo;
        }
        break;
      case ScheduledTime.TWENTY_TWO_TO_TWENTY_THREE:
        {
          result = twentyTwo_to_twentyThree;
        }
        break;
      case ScheduledTime.TWENTY_THREE_TO_MIDNIGHT:
        {
          result = twentyThree_to_midnight;
        }
        break;
      case ScheduledTime.MIDNIGHT_TO_ONE:
        {
          result = midnight_to_one;
        }
        break;
      case ScheduledTime.ONE_TO_TWO:
        {
          result = one_to_two;
        }
        break;
      case ScheduledTime.TWO_TO_THREE:
        {
          result = two_to_three;
        }
        break;
      case ScheduledTime.THREE_TO_FOUR:
        {
          result = three_to_four;
        }
        break;
      case ScheduledTime.FOUR_TO_FIVE:
        {
          result = four_to_five;
        }
        break;
      case ScheduledTime.FIVE_TO_SIX:
        {
          result = five_to_six;
        }
        break;
      case ScheduledTime.SIX_TO_SEVEN:
        {
          result = six_to_seven;
        }
        break;
      case ScheduledTime.SEVEN_TO_EIGHT:
        {
          result = seven_to_eight;
        }
        break;
    }

    return result;

  }

  void setParam(String time, bool withValue){

    switch(time) {
      case ScheduledTime.EIGHT_TO_NINE:
        {
          eight_to_nine = withValue;
        }
        break;
      case ScheduledTime.NINE_TO_TEN:
        {
          nine_to_ten = withValue;
        }
        break;
      case ScheduledTime.TEN_TO_ELEVEN:
        {
          ten_to_eleven = withValue;
        }
        break;
      case ScheduledTime.ELEVEN_TO_TWELVE:
        {
          eleven_to_twelve = withValue;
        }
        break;
      case ScheduledTime.TWELVE_TO_THIRTEEN:
        {
          twelve_to_thirteen = withValue;
        }
        break;
      case ScheduledTime.THIRTEEN_TO_FOURTEEN:
        {
          thirteen_to_fourteen = withValue;
        }
        break;
      case ScheduledTime.FOURTEEN_TO_FIFTEEN:
        {
          fourteen_to_fifteen = withValue;
        }
        break;
      case ScheduledTime.FIFTEEN_TO_SIXTEEN:
        {
          fifteen_to_sixteen = withValue;
        }
        break;
      case ScheduledTime.SIXTEEN_TO_SEVENTEEN:
        {
          sixteen_to_seventeen = withValue;
        }
        break;
      case ScheduledTime.SEVENTEEN_TO_EIGHTEEN:
        {
          seventeen_to_eighteen = withValue;
        }
        break;
      case ScheduledTime.EIGHTEEN_TO_NINETEEN:
        {
          eighteen_to_nineteen = withValue;
        }
        break;
      case ScheduledTime.NINETEEN_TO_TWENTY:
        {
          nineteen_to_twenty = withValue;
        }
        break;
      case ScheduledTime.TWENTY_TO_TWENTY_ONE:
        {
          twenty_to_twentyOne = withValue;
        }
        break;
      case ScheduledTime.TWENTY_ONE_TO_TWENTY_TWO:
        {
          twentyOne_to_twentyTwo = withValue;
        }
        break;
      case ScheduledTime.TWENTY_TWO_TO_TWENTY_THREE:
        {
          twentyTwo_to_twentyThree = withValue;
        }
        break;
      case ScheduledTime.TWENTY_THREE_TO_MIDNIGHT:
        {
          twentyThree_to_midnight = withValue;
        }
        break;
      case ScheduledTime.MIDNIGHT_TO_ONE:
        {
          midnight_to_one = withValue;
        }
        break;
      case ScheduledTime.ONE_TO_TWO:
        {
          one_to_two = withValue;
        }
        break;
      case ScheduledTime.TWO_TO_THREE:
        {
          two_to_three = withValue;
        }
        break;
      case ScheduledTime.THREE_TO_FOUR:
        {
          three_to_four = withValue;
        }
        break;
      case ScheduledTime.FOUR_TO_FIVE:
        {
          four_to_five = withValue;
        }
        break;
      case ScheduledTime.FIVE_TO_SIX:
        {
          five_to_six = withValue;
        }
        break;
      case ScheduledTime.SIX_TO_SEVEN:
        {
          six_to_seven = withValue;
        }
        break;
      case ScheduledTime.SEVEN_TO_EIGHT:
        {
          seven_to_eight = withValue;
        }
        break;
    }

  }

  bool checkSelection(String time){
    bool status = false;

    switch(time) {
      case ScheduledTime.EIGHT_TO_NINE:
        {
          eight_to_nine = !eight_to_nine;
          status = eight_to_nine;
        }
        break;
      case ScheduledTime.NINE_TO_TEN:
        {
          nine_to_ten = !nine_to_ten;
          status = nine_to_ten;
        }
        break;
      case ScheduledTime.TEN_TO_ELEVEN:
        {
          ten_to_eleven = !ten_to_eleven;
          status = ten_to_eleven;
        }
        break;
      case ScheduledTime.ELEVEN_TO_TWELVE:
        {
          eleven_to_twelve = !eleven_to_twelve;
          status = eleven_to_twelve;
        }
        break;
      case ScheduledTime.TWELVE_TO_THIRTEEN:
        {
          twelve_to_thirteen = !twelve_to_thirteen;
          status = twelve_to_thirteen;
        }
        break;
      case ScheduledTime.THIRTEEN_TO_FOURTEEN:
        {
          thirteen_to_fourteen = !thirteen_to_fourteen;
          status = thirteen_to_fourteen;
        }
        break;
      case ScheduledTime.FOURTEEN_TO_FIFTEEN:
        {
          fourteen_to_fifteen = !fourteen_to_fifteen;
          status = fourteen_to_fifteen;
        }
        break;
      case ScheduledTime.FIFTEEN_TO_SIXTEEN:
        {
          fifteen_to_sixteen = !fifteen_to_sixteen;
          status = fifteen_to_sixteen;
        }
        break;
      case ScheduledTime.SIXTEEN_TO_SEVENTEEN:
        {
          sixteen_to_seventeen = !sixteen_to_seventeen;
          status = sixteen_to_seventeen;
        }
        break;
      case ScheduledTime.SEVENTEEN_TO_EIGHTEEN:
        {
          seventeen_to_eighteen = !seventeen_to_eighteen;
          status = seventeen_to_eighteen;
        }
        break;
      case ScheduledTime.EIGHTEEN_TO_NINETEEN:
        {
          eighteen_to_nineteen = !eighteen_to_nineteen;
          status = eighteen_to_nineteen;
        }
        break;
      case ScheduledTime.NINETEEN_TO_TWENTY:
        {
          nineteen_to_twenty = !nineteen_to_twenty;
          status = nineteen_to_twenty;
        }
        break;
      case ScheduledTime.TWENTY_TO_TWENTY_ONE:
        {
          twenty_to_twentyOne = !twenty_to_twentyOne;
          status = twenty_to_twentyOne;
        }
        break;
      case ScheduledTime.TWENTY_ONE_TO_TWENTY_TWO:
        {
          twentyOne_to_twentyTwo = !twentyOne_to_twentyTwo;
          status = twentyOne_to_twentyTwo;
        }
        break;
      case ScheduledTime.TWENTY_TWO_TO_TWENTY_THREE:
        {
          twentyTwo_to_twentyThree = !twentyTwo_to_twentyThree;
          status = twentyTwo_to_twentyThree;
        }
        break;
      case ScheduledTime.TWENTY_THREE_TO_MIDNIGHT:
        {
          twentyThree_to_midnight = !twentyThree_to_midnight;
          status = twentyThree_to_midnight;
        }
        break;
      case ScheduledTime.MIDNIGHT_TO_ONE:
        {
          midnight_to_one = !midnight_to_one;
          status = midnight_to_one;
        }
        break;
      case ScheduledTime.ONE_TO_TWO:
        {
          one_to_two = !one_to_two;
          status = one_to_two;
        }
        break;
      case ScheduledTime.TWO_TO_THREE:
        {
          two_to_three = !two_to_three;
          status = two_to_three;
        }
        break;
      case ScheduledTime.THREE_TO_FOUR:
        {
          three_to_four = !three_to_four;
          status = three_to_four;
        }
        break;
      case ScheduledTime.FOUR_TO_FIVE:
        {
          four_to_five = !four_to_five;
          status = four_to_five;
        }
        break;
      case ScheduledTime.FIVE_TO_SIX:
        {
          five_to_six = !five_to_six;
          status = five_to_six;
        }
        break;
      case ScheduledTime.SIX_TO_SEVEN:
        {
          six_to_seven = !six_to_seven;
          status = six_to_seven;
        }
        break;
      case ScheduledTime.SEVEN_TO_EIGHT:
        {
          seven_to_eight = !seven_to_eight;
          status = seven_to_eight;
        }
        break;
    }

    return status;
  }

  String getFormStatus(){
    String levelStatusMessage = "SUCCESS";

    if (myTextLastnameController.text.trim().isEmpty && !isHelper){
      levelStatusMessage = "Tu dois indiquer ton nom";
      return levelStatusMessage;
    }

    if (myTextFirstnameController.text.trim().isEmpty && !isHelper){
      levelStatusMessage = "Tu dois indiquer ton prénom";
      return levelStatusMessage;
    }

    if (myTextFirstnameController.text.trim().contains("@") && !isHelper){
      levelStatusMessage = "Ton prénom ne doit pas contenir le caractère \'@\'";
      return levelStatusMessage;
    }

    if (myTextFirstnameController.text.trim().contains(".") && !isHelper){
      levelStatusMessage = "Ton prénom ne doit pas contenir le caractère \'.\'";
      return levelStatusMessage;
    }

    if (!primaryLevelState && !collegeLevelState && !highSchoolLevelState
    && !classePreparatoireLevelState && !butDutLevelState && !btsLevelState && !engineeringLevelState
    && !architectLevelState && !commercialLevelState && !medicalLevelState && !artisticLevelState && !otherLevelState)
    {
      levelStatusMessage = "Tu dois sélectionner au moins une catégorie";
      return levelStatusMessage;
    }

    if (primaryLevelState){

      if (false == (listOfKeyWords.contains("cp")
          || listOfKeyWords.contains("ce1")
          || listOfKeyWords.contains("ce2")
          || listOfKeyWords.contains("cm1")
          || listOfKeyWords.contains("cm2"))){
        levelStatusMessage = "Tu dois au moins sélectionner un niveau en primaire !";
        return levelStatusMessage;
      };

    }

    if (collegeLevelState){

      if ( false == (listOfKeyWords.contains("6eme")
          || listOfKeyWords.contains("5eme")
          || listOfKeyWords.contains("4eme")
          || listOfKeyWords.contains("3eme"))){
        levelStatusMessage = "Tu dois au moins sélectionner un niveau au Collège !";
        return levelStatusMessage;
      };
    }



    if (highSchoolLevelState){

      if (false ==(listOfKeyWords.contains("2nde")
          || listOfKeyWords.contains("1ere")
          || listOfKeyWords.contains("terminale"))){
        levelStatusMessage = "Tu dois au moins sélectionner un niveau au Lycée !";
        return levelStatusMessage;
      };

    }

    if (classePreparatoireLevelState){

      if (false == (listOfKeyWords.contains("1ere_annee")
          || listOfKeyWords.contains("2eme_annee"))){
        levelStatusMessage = "Tu dois au moins sélectionner un niveau en classe préparatoire !";
        return levelStatusMessage;
      };

    }

    if (butDutLevelState){

      if (false == (listOfKeyWords.contains("1ere_annee")
          || listOfKeyWords.contains("2eme_annee")
          || listOfKeyWords.contains("3eme_annee"))){
        levelStatusMessage = "Tu dois au moins sélectionner un niveau en BUT/DUT !";
        return levelStatusMessage;
      };


    }

    if (btsLevelState){

      if (false == (listOfKeyWords.contains("1ere_annee")
          || listOfKeyWords.contains("2eme_annee"))){
        levelStatusMessage = "Tu dois au moins sélectionner un niveau en BTS !";
        return levelStatusMessage;
      };

    }


    if (engineeringLevelState){

      if (false == (listOfKeyWords.contains("1ere_annee")
          || listOfKeyWords.contains("2eme_annee")
          || listOfKeyWords.contains("3eme_annee"))){
        levelStatusMessage = "Tu dois au moins sélectionner un niveau en école d'ingénieurs !";
        return levelStatusMessage;
      };


    }

    if (architectLevelState){

      if (false == (listOfKeyWords.contains("1ere_annee")
          || listOfKeyWords.contains("2eme_annee")
          || listOfKeyWords.contains("3eme_annee")
          || listOfKeyWords.contains("4eme_annee")
          || listOfKeyWords.contains("5eme_annee")
      )){
        levelStatusMessage = "Tu dois au moins sélectionner un niveau en école d'architecture !";
        return levelStatusMessage;
      };

    }

    if (commercialLevelState){

      if (false == (listOfKeyWords.contains("1ere_annee")
          || listOfKeyWords.contains("2eme_annee")
          || listOfKeyWords.contains("3eme_annee")
          || listOfKeyWords.contains("4eme_annee")
          || listOfKeyWords.contains("5eme_annee")
      )){
        levelStatusMessage = "Tu dois au moins sélectionner un niveau en école de commerce !";
        return levelStatusMessage;
      };
    }

    if (medicalLevelState){

      if (false == (listOfKeyWords.contains("1ere_annee")
          || listOfKeyWords.contains("2eme_annee")
          || listOfKeyWords.contains("3eme_annee")
          || listOfKeyWords.contains("4eme_annee")
          || listOfKeyWords.contains("5eme_annee")
          || listOfKeyWords.contains("6eme_annee")
          || listOfKeyWords.contains("7eme_annee")
          || listOfKeyWords.contains("8eme_annee")
          || listOfKeyWords.contains("9eme_annee")
          || listOfKeyWords.contains("10eme_annee")
          || listOfKeyWords.contains("11eme_annee")
          || listOfKeyWords.contains("12eme_annee")
      )){
        levelStatusMessage = "Tu dois au moins sélectionner un niveau en études médicales !";
        return levelStatusMessage;
      };

    }

    if (artisticLevelState){

      if (false == (listOfKeyWords.contains("graphisme")
          || listOfKeyWords.contains("musique")
          || listOfKeyWords.contains("animation")
          || listOfKeyWords.contains("design")
          || listOfKeyWords.contains("cinema")
          || listOfKeyWords.contains("audiovisuel")
          || listOfKeyWords.contains("luxe")
          || listOfKeyWords.contains("mode")
          || listOfKeyWords.contains("communication_visuelle")
          || listOfKeyWords.contains("multimedia")
          || listOfKeyWords.contains("theatre")
          || listOfKeyWords.contains("arts")
      )){
        levelStatusMessage = "Tu dois au moins sélectionner un thème en Etudes/Domaines artistiques !";
        return levelStatusMessage;
      };

    }

    if (otherLevelState){
      if (customAddedKeyWords.isEmpty){
        levelStatusMessage = "Tu as sélectionné la catégorie \"Autre\". Tu dois donc ajouter au moins 3 mots-clés !";
        return levelStatusMessage;
      }

      if ("customKeyWordsFailed" == customAddedKeyWords.elementAt(0)){
        return customAddedKeyWords.elementAt(1);
      }

      if (customAddedKeyWords.length <3){
        levelStatusMessage = "Tu as fourni " + customAddedKeyWords.length.toString() + " mot(s)-clé(s) seulement. Or, il en faut 3 au minimum !";
        return levelStatusMessage;
      }
    }

    if ((listOfKeyWords.isEmpty || (listOfKeyWords.length < 3)) && !otherLevelState){
      levelStatusMessage = "Tu dois au minimum sélectionner une catégorie, un niveau et un enseignement !";
      return levelStatusMessage;
    }

    if (customAddedKeyWords.isNotEmpty){
      if ("customKeyWordsFailed" == customAddedKeyWords.elementAt(0)){
        return customAddedKeyWords.elementAt(1);
      }

      listOfKeyWords.addAll(customAddedKeyWords);
    }

    if (myPresentationController.text.trim().isEmpty){
      levelStatusMessage = "Tu as oublié de te présenter !";
      return levelStatusMessage;
    }

    if (myPresentationController.text.trim().length < 100){
      levelStatusMessage = "Ta présentation comporte " + myPresentationController.text.trim().length.toString() + " caractères. Or il faut 100 caractères au minimum !";
      return levelStatusMessage;
    }

    if (myPresentationController.text.trim().contains("@")){
      levelStatusMessage = "Ta présentation ne doit pas contenir d'adresse mail, ni aucun \'@\'.";
      return levelStatusMessage;
    }

    if (myPresentationController.text.trim().contains(RegExp("[a-zA-Z\d]+://(\w+:\w+@)?([a-zA-Z\d.-]+\.[A-Za-z]{2,4})(:\d+)?(/.*)?"))){
      levelStatusMessage = "Ta présentation ne doit pas contenir de lien url.";
      return levelStatusMessage;
    }

    if (myPresentationController.text.trim().contains(RegExp(r'[0-9]'))){
      levelStatusMessage = "Ta présentation ne doit pas contenir de chiffres, ni de numéro de téléphone.";
      return levelStatusMessage;
    }

    return levelStatusMessage;
  }

  clearAllLists(){
    listOfKeyWords.clear();
  }

  setListOfLevels(){
    if (primaryLevelState) {
      //listOfLevels["primaire"] = true;
      listOfKeyWords.add("primaire");
    }
    else
    {
      primaryLevelState_cp = false;
      primaryLevelState_ce1 = false;
      primaryLevelState_ce2 = false;
      primaryLevelState_cm1 = false;
      primaryLevelState_cm2 = false;
    }


    if (collegeLevelState){
      //listOfLevels["college"] = true;
      listOfKeyWords.add("college");
    }
    else{
      collegeLevelState_sixth = false;
      collegeLevelState_fifth = false;
      collegeLevelState_fourth = false;
      collegeLevelState_third = false;
    }

    if (highSchoolLevelState){
      //listOfLevels["lycee"] = true;
      listOfKeyWords.add("lycee");
    }
    else
    {
      highSchoolLevelState_second = false;
      highSchoolLevelState_first = false;
      highSchoolLevelState_terminal = false;
    }

    if (classePreparatoireLevelState){
      listOfKeyWords.addAll(["classe_preparatoire","classe_prepa", "prepa"]);
    }
    else
    {
      classePreparatoireLevelState_first_year = false;
      classePreparatoireLevelState_second_year = false;
    }

    if (butDutLevelState){
      listOfKeyWords.add("dut_but");
      //listOfLevels["but_dut"] = true;
    }
    else
    {
      butDutLevelState_first_year = false;
      butDutLevelState_second_year = false;
      butDutLevelState_third_year = false;
    }

    if (btsLevelState){
      listOfKeyWords.add("bts");
      //listOfLevels["bts"] = true;
    }
    else
    {
      btsLevelState_first_year = false;
      btsLevelState_second_year = false;
    }

    if (engineeringLevelState){
      listOfKeyWords.addAll(["ecole_d'ingenieurs","ingenieur"]);
    }
    else
    {
      engineeringLevelState_first_year = false;
      engineeringLevelState_second_year = false;
      engineeringLevelState_third_year = false;
    }

    if (architectLevelState){
      listOfKeyWords.addAll(["ecole_d'architecture","architecture","architecte"]);
    }
    else
    {
      architectLevelState_first_year = false;
      architectLevelState_second_year = false;
      architectLevelState_third_year = false;
      architectLevelState_fourth_year = false;
      architectLevelState_fifth_year = false;
    }

    if (commercialLevelState){
      listOfKeyWords.addAll(["ecole_de_commerce","commerce"]);
    }
    else
    {
      commercialLevelState_first_year = false;
      commercialLevelState_second_year = false;
      commercialLevelState_third_year = false;
      commercialLevelState_fourth_year = false;
      commercialLevelState_fifth_year = false;
    }

    if (medicalLevelState){
      listOfKeyWords.addAll(
          [
            "etudes_medicales",
            "etudes_de_medecine",
            "faculte_de_medecine",
            "medecine",
            "medical",
            "medicale",
            "medicales"
          ]
      );
    }
    else
    {
      medicalLevelState_first_cycle = false;
      medicalLevelState_second_cycle = false;
      medicalLevelState_third_cycle = false;
    }

    if (artisticLevelState){
      listOfKeyWords.addAll(["etudes_d'arts","ecole_d'arts"]);
    }
    else
    {

      artisticLevelState_graphics = false;
      artisticLevelState_music = false;
      artisticLevelState_animation = false;
      artisticLevelState_design = false;
      artisticLevelState_audiovisual = false;
      artisticLevelState_cinema = false;
      artisticLevelState_luxury = false;
      artisticLevelState_mode = false;
      artisticLevelState_visual_communication = false;
      artisticLevelState_multimedia = false;
      artisticLevelState_theater = false;
      artisticLevelState_arts = false;

    }


  }

  setListOfClasses(){

    if (primaryLevelState_cp) {listOfKeyWords.add("cp");}
    if (primaryLevelState_ce1) {listOfKeyWords.add("ce1");}
    if (primaryLevelState_ce2) {listOfKeyWords.add("ce2");
    if (primaryLevelState_cm1) {listOfKeyWords.add("cm1");}}
    if (primaryLevelState_cm2) {listOfKeyWords.add("cm2");}
    if (collegeLevelState_sixth) {listOfKeyWords.addAll(["6eme","sixieme","6e"]);}
    if (collegeLevelState_fifth) {listOfKeyWords.addAll(["5eme","cinquieme","5e"]);}
    if (collegeLevelState_fourth) {listOfKeyWords.addAll(["4eme","quatrieme","4e"]);}
    if (collegeLevelState_third) {listOfKeyWords.addAll(["2eme","troisieme","3e"]);}
    if (highSchoolLevelState_second) {listOfKeyWords.addAll(["2nde","seconde"]);}
    if (highSchoolLevelState_first) {listOfKeyWords.addAll(["1ere","premiere"]);}
    if (highSchoolLevelState_terminal) {listOfKeyWords.add("terminale");}
    if (classePreparatoireLevelState_first_year) {listOfKeyWords.addAll(["premiere_annee","1ere_annee","premiere_annee","licence_1"]);}
    if (classePreparatoireLevelState_second_year) {listOfKeyWords.addAll(["deuxieme_annee","2eme_annee","licence_2"]);}
    if (butDutLevelState_first_year) {listOfKeyWords.addAll(["premiere_annee","1ere_annee","licence_1"]);}
    if (butDutLevelState_second_year) {listOfKeyWords.addAll(["deuxieme_annee","2eme_annee","licence_2"]);}
    if (butDutLevelState_third_year) {listOfKeyWords.addAll(["troisieme_annee","3eme_annee","licence_3"]);}
    if (btsLevelState_first_year) {listOfKeyWords.addAll(["premiere_annee","1ere_annee","licence_1"]);}
    if (btsLevelState_second_year) {listOfKeyWords.addAll(["deuxieme_annee","2eme_annee","licence_2"]);}
    if (engineeringLevelState_first_year) {listOfKeyWords.addAll(["premiere_annee","1ere_annee","licence_3"]);}
    if (engineeringLevelState_second_year) {listOfKeyWords.addAll(["deuxieme_annee","2eme_annee","master_1"]);}
    if (engineeringLevelState_third_year) {listOfKeyWords.addAll(["troisieme_annee","3eme_annee","master_2"]);}
    if (architectLevelState_first_year) {listOfKeyWords.addAll(["premiere_annee","1ere_annee","licence_1"]);}
    if (architectLevelState_second_year) {listOfKeyWords.addAll(["deuxieme_annee","2eme_annee","licence_2"]);}
    if (architectLevelState_third_year) {listOfKeyWords.addAll(["troisieme_annee","3eme_annee","licence_3"]);}
    if (architectLevelState_fourth_year) {listOfKeyWords.addAll(["quatrieme_annee","4eme_annee","master_1"]);}
    if (architectLevelState_fifth_year) {listOfKeyWords.addAll(["cinquieme_annee","5eme_annee","master_2"]);}
    if (commercialLevelState_second_year) {listOfKeyWords.addAll(["deuxieme_annee","2eme_annee","licence_2"]);}
    if (commercialLevelState_third_year) {listOfKeyWords.addAll(["troisieme_annee","3eme_annee","licence_3"]);}
    if (commercialLevelState_fourth_year) {listOfKeyWords.addAll(["quatrieme_annee","4eme_annee","master_1"]);}
    if (commercialLevelState_fifth_year) {listOfKeyWords.addAll(["cinquieme_annee","5eme_annee","master_2"]);}
    if (medicalLevelState_first_cycle) {listOfKeyWords.addAll(["1er_cycle","premiere_cycle","1ere_annee","2eme_annee","3eme_annee"]);}
    if (medicalLevelState_second_cycle) {listOfKeyWords.addAll(["2eme_cycle","deuxieme_cycle","4eme_annee","5eme_anne","6eme_annee"]);}
    if (medicalLevelState_third_cycle) {listOfKeyWords.addAll(["3eme_cycle","troisieme_cycle","7eme_annee","8eme_annee","9eme_annee","10eme_annee","11eme_annee","12eme_annee"]);}
  }

  setListOfSubjects(){

    if (primarySubjectState_maths) {listOfKeyWords.addAll(["maths","mathematiques","mathematique"]);}
    if (primarySubjectState_physics) listOfKeyWords.add("physique");
    if (primarySubjectState_chemistry) listOfKeyWords.add("chimie");
    if (primarySubjectState_physics && primarySubjectState_chemistry) {listOfKeyWords.addAll(["physique-chimie","physique_chimie","6e"]);}
    if (primarySubjectState_french) listOfKeyWords.add("francais");
    if (primarySubjectState_history) listOfKeyWords.add("histoire");
    if (primarySubjectState_geography) listOfKeyWords.add("geographie");
    if (primarySubjectState_english) listOfKeyWords.add("anglais");
    if (primarySubjectState_spanish) listOfKeyWords.add("espagnol");
    if (primarySubjectState_svt) listOfKeyWords.add("svt");
    if (primarySubjectState_technology) listOfKeyWords.add("technologie");
    if (primarySubjectState_german) listOfKeyWords.add("allemand");
    if (primarySubjectState_philosophy) listOfKeyWords.add("philosophie");
    if (primarySubjectState_literature) listOfKeyWords.add("litterature");
    if (primarySubjectState_ses) {listOfKeyWords.addAll(["ses","science_economique_sociale","6e"]);}
    if (primarySubjectState_latin) listOfKeyWords.add("latin");
    if (primarySubjectState_biology) listOfKeyWords.add("biologie");
    if (primarySubjectState_si) {listOfKeyWords.addAll(["si","sciences_de_l'ingenieur"]);}
    if (primarySubjectState_arts) listOfKeyWords.add("arts");
    if (primarySubjectState_italian) listOfKeyWords.add("italien");
    if (primarySubjectState_arab) listOfKeyWords.add("arabe");
    if (primarySubjectState_chinese) listOfKeyWords.add("chinois");
    if (primarySubjectState_hebrew) listOfKeyWords.add("hebreu");
    if (primarySubjectState_portuguese) listOfKeyWords.add("portugais");
    if (primarySubjectState_russian) listOfKeyWords.add("russe");
    if (primarySubjectState_japanese) listOfKeyWords.add("japonais");
    if (primarySubjectState_dutch) listOfKeyWords.add("neerlandais");

    if (secondarySubjectState_programming) listOfKeyWords.add("informatique");
    if (secondarySubjectState_communication) listOfKeyWords.add("communication");
    if (secondarySubjectState_chemistry) listOfKeyWords.add("chimie");
    if (secondarySubjectState_genius_civil) listOfKeyWords.add("genie_civil");
    if (secondarySubjectState_genius_mechanic) listOfKeyWords.add("genie_mecanique");
    if (secondarySubjectState_genius_thermal) listOfKeyWords.add("genie_thermique");
    if (secondarySubjectState_genius_industrial) listOfKeyWords.add("genie_industriel");
    if (secondarySubjectState_genius_chemistry) listOfKeyWords.add("genie_chimique");
    if (secondarySubjectState_genius_biologic) listOfKeyWords.add("genie_biologique");
    if (secondarySubjectState_genius_programming) listOfKeyWords.add("genie_informatique");
    if (secondarySubjectState_administration_management) listOfKeyWords.add("gestion_administrative");
    if (secondarySubjectState_companies_management) listOfKeyWords.add("gestion_des_entreprises");
    if (secondarySubjectState_telecoms_network) {listOfKeyWords.addAll(["reseaux_et_telecoms","reseaux_et_telecommunications"]);}
    if (secondarySubjectState_legal_careers) listOfKeyWords.add("carrieres_juridiques");
    if (secondarySubjectState_social_careers) listOfKeyWords.add("carrieres_sociales");
    if (secondarySubjectState_physics_measures) listOfKeyWords.add("mesures_physiques");


    if (secondarySubjectState_design) listOfKeyWords.add("design");
    if (secondarySubjectState_audiovisual) listOfKeyWords.add("audiovisuel");
    if (secondarySubjectState_insurance) listOfKeyWords.add("assurance");
    if (secondarySubjectState_bank) listOfKeyWords.add("banque");
    if (secondarySubjectState_management) listOfKeyWords.add("management");
    if (secondarySubjectState_sale) listOfKeyWords.add("vente");
    if (secondarySubjectState_accounting) listOfKeyWords.add("comptabilite");
    if (secondarySubjectState_building) listOfKeyWords.add("batiment");
    if (secondarySubjectState_public_works) listOfKeyWords.add("travaux_publics");
    if (secondarySubjectState_electronic) listOfKeyWords.add("electronique");
    if (secondarySubjectState_electrical_engineering) listOfKeyWords.add("electrotechnique");
    if (secondarySubjectState_hotel) listOfKeyWords.add("hotellerie");
    if (secondarySubjectState_restaurant) listOfKeyWords.add("restauration");
    if (secondarySubjectState_tourism) listOfKeyWords.add("tourisme");
    if (secondarySubjectState_mechanic) listOfKeyWords.add("mecanique");
    if (secondarySubjectState_automatism) listOfKeyWords.add("automatisme");
    if (secondarySubjectState_metallic_constructions) listOfKeyWords.add("constructions_metalliques");
    if (secondarySubjectState_health) listOfKeyWords.add("sante");
    if (secondarySubjectState_paramedic) listOfKeyWords.add("paramedical");
    if (secondarySubjectState_social) listOfKeyWords.add("social");

    if (secondarySubjectState_marketing) listOfKeyWords.add("marketing");
    if (secondarySubjectState_financial_management) listOfKeyWords.add("gestion_financiere");
    if (secondarySubjectState_energy) listOfKeyWords.add("energie");
    if (secondarySubjectState_economy) listOfKeyWords.add("economie");
    if (secondarySubjectState_human_sciences) listOfKeyWords.add("sciences_humaines");

    if (secondarySubjectState_space_geometry) listOfKeyWords.add("geometrie_dans_l'espace");
    if (secondarySubjectState_law) listOfKeyWords.add("droit");
    if (secondarySubjectState_sociology) listOfKeyWords.add("sociologie");
    if (secondarySubjectState_material_resistance) listOfKeyWords.add("resistance_des_materiaux");
    if (secondarySubjectState_acoustic) listOfKeyWords.add("acoustique");
    if (secondarySubjectState_road) listOfKeyWords.add("voirie");
    if (secondarySubjectState_architecture_history) listOfKeyWords.add("histoire_de_l'architecture");

    if (secondarySubjectState_office_automation) listOfKeyWords.add("bureautique");
    if (secondarySubjectState_project_management) listOfKeyWords.add("gestion_de_projet");
    if (secondarySubjectState_finance) listOfKeyWords.add("finance");
    if (secondarySubjectState_taxation) listOfKeyWords.add("fiscalite");
    if (secondarySubjectState_human_resources) listOfKeyWords.add("ressources_humaines");
    if (secondarySubjectState_statistics) listOfKeyWords.add("statistiques");

    if (secondarySubjectState_medical_specialities) listOfKeyWords.add("specialites_medicales");
    if (secondarySubjectState_work_medicine) listOfKeyWords.add("medecine_du_travail");
    if (secondarySubjectState_public_health) listOfKeyWords.add("sante_publique");
    if (secondarySubjectState_surgical_specialities) listOfKeyWords.add("specialites_chirurgicales");
    if (secondarySubjectState_medical_biology) listOfKeyWords.add("biologie_medicale");
    if (secondarySubjectState_psychiatry) listOfKeyWords.add("psychiatrie");
    if (secondarySubjectState_gynecologist) listOfKeyWords.add("gynecologie");
    if (secondarySubjectState_obstetrics_pediatrics) listOfKeyWords.add("obstetrique_pediatrie");
    if (secondarySubjectState_anesthesiology) listOfKeyWords.add("anesthesiologie");
    if (secondarySubjectState_surgical_resuscitation) listOfKeyWords.add("reanimation_chirurgicale");
    if (secondarySubjectState_general_medicine) listOfKeyWords.add("medecine_generale");

    if (artisticLevelState_graphics) listOfKeyWords.add("graphisme");
    if (artisticLevelState_music) listOfKeyWords.add("musique");
    if (artisticLevelState_animation) listOfKeyWords.add("animation");
    if (artisticLevelState_design) listOfKeyWords.add("design");
    if (artisticLevelState_audiovisual) listOfKeyWords.add("audiovisuel");
    if (artisticLevelState_cinema) listOfKeyWords.add("cinema");
    if (artisticLevelState_luxury) listOfKeyWords.add("luxe");
    if (artisticLevelState_mode) listOfKeyWords.add("mode");
    if (artisticLevelState_visual_communication) listOfKeyWords.add("communication_visuelle");
    if (artisticLevelState_multimedia) listOfKeyWords.add("multimedia");
    if (artisticLevelState_theater) listOfKeyWords.add("theatre");
    if (artisticLevelState_arts) listOfKeyWords.add("arts");

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Je propose mes services',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.yellow,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
                size: 30,
                ),
              onPressed: () {
                if (thirdPage){
                  Navigator.pop(context);
                  /*Navigator.push(context, MaterialPageRoute(
                      builder: (context) => HelperIncomePage()
                  ));*/
                }else{
                  Navigator.pop(context);
                }

              },
            ),
          ),
          body:
          /*thirdPage ?
              HelperCertificationFormPage(disableAppBar: true) :*/
          (secondPage ?
          SingleChildScrollView(
            controller: _scrollController,
              child:
              Column(
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text("Un utilisateur peut décider de s'abonner à toi et opter pour des LIVEs réguliers ! \n\n"
                          "NOTE: les LIVEs peuvent être réalisés à n'importe quel moment de la journée, "
                          "de minuit à minuit, 24h/24. Choisis donc les horaires qui te conviennent.",
                          style: GoogleFonts.inter(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w700
                          ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: listOfDays.map(
                            (element) {
                          return Row(
                            children: [
                              InkWell(
                                onTap:(){

                                  checkDayConfig(_selectedDay!);

                                  if (!isDayConfigDone(element)){
                                    setState(() {
                                      resetLiveTimes();
                                      _selectedDay = element;
                                      /*allLivesButtonsParams[CommonFunctionsManager.getDayTranslation(_selectedDay!)]!.forEach((key, value) {
                                        setParam(key, value);
                                      });*/
                                    });
                                  }

                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration:  BoxDecoration(
                                    color: isDayConfigDone(element) ? Colors.greenAccent : ((element == _selectedDay) ? Colors.blueAccent : Colors.grey),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                      child: isDayConfigDone(element) ?
                                          Icon(Icons.check,color: Colors.orange,size: 15,)
                                          :
                                          Text(
                                            element.substring(0,3) +".",
                                            style: (element == _selectedDay) ? GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ) : null,
                                          )

                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                            ],
                          );
                        }
                    ).toList(),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Text(
                      _selectedDay!.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                  Center(
                    child: Container(
                      child: Column(
                            children: [
                              DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'Horaires',
                                        style: TextStyle(fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Tes disponibilités",
                                        style: TextStyle(fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                  rows: g_scheduledLives.map(
                                          (element){
                                        return DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(element)),
                                            DataCell(
                                                Center(
                                                  child:
                                                  StatefulBuilder(
                                                    builder: (context, changeState) {
                                                    return ElevatedButton(
                                                          onPressed:() async {

                                                            if (true/*allIndexesDataForCannotDeleteWithExistingUser[CommonFunctionsManager.getDayTranslation(_selectedDay!)]!.keys.contains(g_scheduledLives.indexOf(element))*/){
                                                              /*AlertDialogManager.shortDialog(
                                                                  context,
                                                                  "Action impossible",
                                                                  contentMessage: "Tu ne peux pas modifier cet horaire car tu as actuellement un rendez-vous de prévu avec une personne sur ce même créneau ! \n\n Rends-toi à ton Home, puis dans 'Mes rendez-vous' pour annuler le RDV en question."
                                                              );*/
                                                            }
                                                            else if (getParam(element))
                                                            {
                                                              //daysScheduledLives[CommonFunctionsManager.getDayTranslation(_selectedDay!)].remove(g_scheduledLives.indexOf(element));
                                                              changeState(() {
                                                                //allLivesButtonsParams[CommonFunctionsManager.getDayTranslation(_selectedDay!)]![element] = checkSelection(element);
                                                              });
                                                            }
                                                            else
                                                            {
                                                              if (true/*!daysScheduledLives[CommonFunctionsManager.getDayTranslation(_selectedDay!)].contains(g_scheduledLives.indexOf(element))*/)
                                                              {
                                                                //daysScheduledLives[CommonFunctionsManager.getDayTranslation(_selectedDay!)].add(g_scheduledLives.indexOf(element));
                                                              }
                                                              changeState(() {
                                                                //allLivesButtonsParams[CommonFunctionsManager.getDayTranslation(_selectedDay!)]![element] = checkSelection(element);
                                                              });
                                                            }
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            shape: StadiumBorder(),
                                                            primary: getParam(element) ? Colors.grey[300] : Colors.green,
                                                          ),
                                                          child:
                                                          Text(
                                                            getParam(element) ? "Validé" : "Ajouter",
                                                            style: GoogleFonts.inter(
                                                              color: getParam(element) ? Colors.grey[600] : Colors.white,
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          )
                                                        );
                                                    }
                                                  ),
                                                )
                                            ),
                                          ],
                                        );
                                      }).toList()
                              ),
                              Row(
                                children: [
                                  Container(
                                  height: 50,
                                  width: 50,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    value: checkDayAvailability(_selectedDay!),
                                    onChanged: (bool? value) {

                                      if (true/*daysScheduledLives[CommonFunctionsManager.getDayTranslation(_selectedDay!)].isEmpty*/){
                                        setState(() {
                                          setDayAvailability(_selectedDay!);
                                        });
                                      }
                                      else
                                      {
                                        //AlertDialogManager.showHelperFormDialog(context,"Cette case ne peut pas être cochée car un  ou plusieurs horaires ont été ajoutés pour " + _selectedDay!.toUpperCase() + ".");
                                      }
                                    },
                                  )
                              ),
                              Expanded(
                                child: Text("Je ne suis pas disponible les " + _selectedDay!.toUpperCase() + "S",
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),),
                              ),
                                ],
                              )
                            ],
                          )
                    ),
                  ),
              SizedBox(height: 40),
              Center(
                  child: StatefulBuilder(
                    builder: (context, changeState) {
                      return Container(
                        width: 300,
                        height: 70,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.red,
                            ),
                            child: isLoading ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    'TRAITEMENT EN COURS',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(color: Colors.white,)
                                ),
                              ],
                            ) : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SUIVANT',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.arrow_right_alt, size: 25),
                              ],
                            ),
                            onPressed: () async {

                              changeState(() {
                                isLoading = true;
                              });

                              await Future.delayed(Duration(seconds: 3));
                              String finalStatus = getFinalScheduledLivesStatus();

                              if("SUCCESS" == finalStatus){

                                sortScheduledDaysLives();

                                DatabaseService newService =  DatabaseService(_userManager.userId!);
                                await newService.updateUserHelperEarnings(_userManager);
                                await newService.updateUserHelper(data, _userManager);
                                await newService.updateUserHelperScheduledLives(finalDaysScheduledLives);

                                setState(() {
                                  thirdPage = true;
                                });

                              }
                              else
                              {
                                _scrollController.animateTo(0,
                                  duration: const Duration(microseconds: 500), curve: Curves.linear);
                                //AlertDialogManager.showHelperFormDialog(context, finalStatus);
                                changeState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          ),
                      );
                    }
                  )
                  ),
                  SizedBox(height: 40),
                ],
              )
          )
              :
          SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            isHelper ?
             Container()
            :
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Comment t'appelles-tu ?",
                      style: GoogleFonts.poppins(
                        color: Colors.orange[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: 200,
                      height:40,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4,
                                offset: Offset(0,3)
                            ),
                          ]
                      ),
                      child:TextField(
                        controller: myTextLastnameController,
                        decoration: InputDecoration(
                          hintText: 'Nom',
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: 200,
                      height:40,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 4,
                                offset: Offset(0,3)
                            ),
                          ]
                      ),
                      child:TextField(
                        controller: myTextFirstnameController,
                        decoration: InputDecoration(
                          hintText: 'Prénom',
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Sélectionnes les catégories dans lesquels tu peux apporter ton service ?",
                  style: GoogleFonts.poppins(
                    color: Colors.orange[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: primaryLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            primaryLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("Primaire",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              PrimaryLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: collegeLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            collegeLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("College",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              CollegeLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: highSchoolLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            highSchoolLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("Lycée",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              HighSchoolLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: classePreparatoireLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            classePreparatoireLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("Classe Préparatoire",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              ClassePreparatoireLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: butDutLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            butDutLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("BUT / DUT",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              ButDutLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: btsLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            btsLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("BTS",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              BtsLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: engineeringLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            engineeringLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("Ecole d'ingénieurs",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              SchoolEngineeringLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: architectLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            architectLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("Ecole d'architecture",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              SchoolArchitectLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: commercialLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            commercialLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("Ecole de commerce",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              SchoolCommercialLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: medicalLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            medicalLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("Etudes médicales / Médecine",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              MedicalLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("Etudes/Domaines artistiques",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),
              ArtisticLevel(),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 50,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: otherLevelState,
                        onChanged: (bool? value) {
                          setState(() {
                            otherLevelState = value!;
                          });
                        },
                      )
                  ),
                  Expanded(
                    child: Text("Autre",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Dans quels enseignements ?",
                  style: GoogleFonts.poppins(
                    color: Colors.orange[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              AllPrimarySubjects(),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Tu possèdes d'autres compétences ?",
                  style: GoogleFonts.poppins(
                    color: Colors.orange[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              AllSecondarySubjects(),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Ajoutes tes propres mots-clés",
                  style: GoogleFonts.poppins(
                    color: Colors.orange[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Si tu souhaites apporter plus de précisions ou que les propositions précédentes ne te correspondent pas, et bien définis tes propres mots-clés ! Chaque mot-clé doit être séparé par une virgule (jusqu'à 3 mots-clés maximum):",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomKeywords((_customAddedKeyWords){
                customAddedKeyWords = _customAddedKeyWords;
              }),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enfin, présentes-toi 😁",
                  style: GoogleFonts.poppins(
                    color: Colors.orange[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Cette présentation sera visible par tout le monde! Alors n'hésites pas à fournir autant de détails que tu peux afin de réaliser la description qui te représentera le mieux et ainsi être original ! (ta personnailité, tes hobbies, etc...)",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left:10.0, right:10.0),
                child: Container(
                  height:200,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            offset: Offset(0,3)
                        ),
                      ]
                  ),
                  child: TextField(
                    controller: myPresentationController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "Exemple: Coucou moi c'est Julie, et j'aime trop aider les autres 🙂 Les maths, l'anglais et la physique-chimie sont mes matières préférées ☀ donc si tu es au collège ou au Lycée et que tu as des blocages, et bien n'hésites pas! \nAussi, j'aime beaucoup les dessins animés et les mangas, et je m'en sers souvent pour expliquer certaines notions 👍 👍 👍",
                      hintMaxLines: 10,
                      hintStyle: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic
                      ),
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 300,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.red,
                      ),
                      child: isLoading ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'TRAITEMENT EN COURS',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(color: Colors.white,)
                          ),
                        ],
                      ) : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SUIVANT',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(Icons.arrow_right_alt, size: 25),
                        ],
                      ),
                      onPressed: () async {

                        User? currentUser = FirebaseAuth.instance.currentUser;
                        await currentUser?.reload();
                        if(currentUser != null)
                        {
                          currentUser = FirebaseAuth.instance.currentUser;

                          if(!currentUser!.emailVerified && (currentUser.phoneNumber == null)){
                            print("Error: l'utilisateur n'est pas vérifié");
                            //AlertDialogManager.showMailVerificationDialog(context, currentUser.email!);
                            currentUser.sendEmailVerification();
                          }else{
                            setListOfLevels();
                            setListOfClasses();
                            setListOfSubjects();
                            //debugPrint("DEBUG_LOG LISTKEYS listOfKeyWords=" + listOfKeyWords.toString());
                            String p_status = getFormStatus();

                            if("SUCCESS" == p_status){

                              if (!isHelper){
                                data = {
                                  //'first_name': CommonFunctionsManager.capitalize(myTextFirstnameController.text.trim()),
                                  'last_name': myTextLastnameController.text.trim().toUpperCase(),
                                  'presentation': myPresentationController.text.trim(),
                                  'keywords': listOfKeyWords
                                  //'competences':competences
                                };
                              }
                              else
                              {
                                data = {
                                  'keywords':listOfKeyWords,
                                  'presentation': myPresentationController.text.trim()
                                  //'competences':competences
                                };
                              }

                              setState(() {
                                secondPage = true;
                              });

                            }
                            else{
                              setState(() {
                                isLoading = false;
                              });
                              clearAllLists();
                              //AlertDialogManager.showHelperFormDialog(context,p_status);
                            }
                          }

                        }else{
                          setState(() {
                            isLoading = false;
                          });
                          clearAllLists();
                          //AlertDialogManager.showHelperFormDialog(context,"Tu es déconnecté(e) du réseau.");
                        }

                      }

                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ]
            )
          )
        )
      ),
    );
  }


  Widget PrimaryLevel() {
    return Visibility(
        visible: primaryLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: primaryLevelState_cp,
                        onChanged: (bool? value) {
                          setState(() {
                            primaryLevelState_cp = value!;
                          });
                        },
                      ),
                      Text("CP"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: primaryLevelState_ce1,
                        onChanged: (bool? value) {
                          setState(() {
                            primaryLevelState_ce1 = value!;
                          });
                        },
                      ),
                      Text("CE1"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: primaryLevelState_ce2,
                        onChanged: (bool? value) {
                          setState(() {
                            primaryLevelState_ce2 = value!;
                          });
                        },
                      ),
                      Text("CE2"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: primaryLevelState_cm1,
                        onChanged: (bool? value) {
                          setState(() {
                            primaryLevelState_cm1 = value!;
                          });
                        },
                      ),
                      Text("CM1"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: primaryLevelState_cm2,
                        onChanged: (bool? value) {
                          setState(() {
                            primaryLevelState_cm2 = value!;
                          });
                        },
                      ),
                      Text("CM2"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget CollegeLevel() {
    return Visibility(
        visible: collegeLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: collegeLevelState_sixth,
                        onChanged: (bool? value) {
                          setState(() {
                            collegeLevelState_sixth = value!;
                          });
                        },
                      ),
                      Text("6ème"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: collegeLevelState_fifth,
                        onChanged: (bool? value) {
                          setState(() {
                            collegeLevelState_fifth = value!;
                          });
                        },
                      ),
                      Text("5ème"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: collegeLevelState_fourth,
                        onChanged: (bool? value) {
                          setState(() {
                            collegeLevelState_fourth = value!;
                          });
                        },
                      ),
                      Text("4ème"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: collegeLevelState_third,
                        onChanged: (bool? value) {
                          setState(() {
                            collegeLevelState_third = value!;
                          });
                        },
                      ),
                      Text("3ème"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget HighSchoolLevel() {
    return Visibility(
        visible: highSchoolLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: highSchoolLevelState_second,
                        onChanged: (bool? value) {
                          setState(() {
                            highSchoolLevelState_second = value!;
                          });
                        },
                      ),
                      Text("2nde"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: highSchoolLevelState_first,
                        onChanged: (bool? value) {
                          setState(() {
                            highSchoolLevelState_first = value!;
                          });
                        },
                      ),
                      Text("1ère"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: highSchoolLevelState_terminal,
                        onChanged: (bool? value) {
                          setState(() {
                            highSchoolLevelState_terminal = value!;
                          });
                        },
                      ),
                      Text("Terminale"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }


  Widget AllPrimarySubjects() {
    final ScrollController _horizontalScrollController = ScrollController();
    final ScrollController _verticalScrollController = ScrollController();

    return Row(
      children: [
        Expanded(
          child: Container(
              height: 222,
              decoration: BoxDecoration(
                  color: Colors.blue[200],
                  border: Border.all(
                      color: Colors.red,
                      width: 2
                  )
              ),
              child:AdaptiveScrollbar(
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: Colors.orange.withOpacity(0.7),
                sliderActiveColor: Colors.orange,
                controller: _verticalScrollController,
                child: AdaptiveScrollbar(
                  controller: _horizontalScrollController,
                  position: ScrollbarPosition.bottom,
                  underColor: Colors.blueGrey.withOpacity(0.3),
                  sliderDefaultColor: Colors.grey.withOpacity(0.7),
                  sliderActiveColor: Colors.grey,
                    child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    scrollDirection: Axis.vertical,
                      child:SingleChildScrollView(
                        controller: _horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_maths,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_maths = value!;
                                    });
                                  },
                                ),
                                Text("Maths"),
                              ],
                            ),


                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_physics,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_physics = value!;
                                    });
                                  },
                                ),
                                Text("Physique"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_chemistry,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_chemistry = value!;
                                    });
                                  },
                                ),
                                Text("Chimie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_french,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_french = value!;
                                    });
                                  },
                                ),
                                Text("Français"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_history,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_history = value!;
                                    });
                                  },
                                ),
                                Text("Histoire"),
                              ],
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_geography,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_geography = value!;
                                    });
                                  },
                                ),
                                Text("Géographie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_english,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_english = value!;
                                    });
                                  },
                                ),
                                Text("Anglais"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_spanish,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_spanish = value!;
                                    });
                                  },
                                ),
                                Text("Espagnol"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_svt,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_svt = value!;
                                    });
                                  },
                                ),
                                Text("SVT (Sciences de la vie et de la terre)"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_technology,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_technology = value!;
                                    });
                                  },
                                ),
                                Text("Technologie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_german,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_german = value!;
                                    });
                                  },
                                ),
                                Text("Allemand"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_philosophy,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_philosophy = value!;
                                    });
                                  },
                                ),
                                Text("Philosophie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_literature,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_literature = value!;
                                    });
                                  },
                                ),
                                Text("Littérature"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_ses,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_ses = value!;
                                    });
                                  },
                                ),
                                Text("SES (Sciences économiques et sociales)"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_latin,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_latin = value!;
                                    });
                                  },
                                ),
                                Text("Latin"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_biology,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_biology = value!;
                                    });
                                  },
                                ),
                                Text("Biologie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_si,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_si = value!;
                                    });
                                  },
                                ),
                                Text("SI (Sciences de l'ingénieur)"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_arts,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_arts = value!;
                                    });
                                  },
                                ),
                                Text("Arts"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_italian,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_italian = value!;
                                    });
                                  },
                                ),
                                Text("Italien"),
                              ],
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_arab,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_arab = value!;
                                    });
                                  },
                                ),
                                Text("Arabe"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_chinese,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_chinese = value!;
                                    });
                                  },
                                ),
                                Text("Chinois"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_hebrew,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_hebrew = value!;
                                    });
                                  },
                                ),
                                Text("Hébreu"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_portuguese,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_portuguese = value!;
                                    });
                                  },
                                ),
                                Text("Portuguais"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_russian,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_russian = value!;
                                    });
                                  },
                                ),
                                Text("Russe"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_japanese,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_japanese = value!;
                                    });
                                  },
                                ),
                                Text("Japonais"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: primarySubjectState_dutch,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      primarySubjectState_dutch = value!;
                                    });
                                  },
                                ),
                                Text("Néerlandais"),
                              ],
                            ),


                          ],
                        )
                        )
                      )
                    )
                  )
          ),
        ),
      ],
    );

  }


  Widget AllSecondarySubjects() {
    final ScrollController _horizontalScrollController = ScrollController();
    final ScrollController _verticalScrollController = ScrollController();

    return Container(
        height: 366,
        decoration: BoxDecoration(
            color: Colors.blue[200],
            border: Border.all(
                color: Colors.red,
                width: 2
            )
        ),
        child:AdaptiveScrollbar(
            underColor: Colors.blueGrey.withOpacity(0.3),
            sliderDefaultColor: Colors.orange.withOpacity(0.7),
            sliderActiveColor: Colors.orange,
            controller: _verticalScrollController,
            child: AdaptiveScrollbar(
                controller: _horizontalScrollController,
                position: ScrollbarPosition.bottom,
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: Colors.grey.withOpacity(0.7),
                sliderActiveColor: Colors.grey,
                child: SingleChildScrollView(
                    controller: _verticalScrollController,
                    scrollDirection: Axis.vertical,
                    child:SingleChildScrollView(
                        controller: _horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_programming,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_programming = value!;
                                    });
                                  },
                                ),
                                Text("Informatique (programmation)"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_management,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_management = value!;
                                    });
                                  },
                                ),
                                Text("Management"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_restaurant,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_restaurant = value!;
                                    });
                                  },
                                ),
                                Text("Restauration"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_law,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_law = value!;
                                    });
                                  },
                                ),
                                Text("Droit"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_medical_specialities,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_medical_specialities = value!;
                                    });
                                  },
                                ),
                                Text("Spécialités médicales"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_sale,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_sale = value!;
                                    });
                                  },
                                ),
                                Text("Vente"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_communication,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_communication = value!;
                                    });
                                  },
                                ),
                                Text("Communication"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_administration_management,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_administration_management = value!;
                                    });
                                  },
                                ),
                                Text("Gestion administratives"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_office_automation,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_office_automation = value!;
                                    });
                                  },
                                ),
                                Text("Bureautique (Word,Excel,etc)"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_project_management,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_project_management = value!;
                                    });
                                  },
                                ),
                                Text("Gestion de projet"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_general_medicine,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_general_medicine = value!;
                                    });
                                  },
                                ),
                                Text("Médecine générale"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_genius_civil,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_genius_civil = value!;
                                    });
                                  },
                                ),
                                Text("Génie civil"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_genius_mechanic,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_genius_mechanic = value!;
                                    });
                                  },
                                ),
                                Text("Génie mécanique"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_genius_thermal,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_genius_thermal = value!;
                                    });
                                  },
                                ),
                                Text("Génie thermique"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_genius_chemistry,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_genius_chemistry = value!;
                                    });
                                  },
                                ),
                                Text("Génie chimique"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_genius_biologic,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_genius_biologic = value!;
                                    });
                                  },
                                ),
                                Text("Génie biologique"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_genius_programming,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_genius_programming = value!;
                                    });
                                  },
                                ),
                                Text("Génie informatique"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_companies_management,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_companies_management = value!;
                                    });
                                  },
                                ),
                                Text("Gestion des entreprises"),
                              ],
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_telecoms_network,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_telecoms_network = value!;
                                    });
                                  },
                                ),
                                Text("Réseaux et Télécommunications"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_legal_careers,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_legal_careers = value!;
                                    });
                                  },
                                ),
                                Text("Carrières juridiques"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_social_careers,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_social_careers = value!;
                                    });
                                  },
                                ),
                                Text("Carrières sociales"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_physics_measures,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_physics_measures = value!;
                                    });
                                  },
                                ),
                                Text("Mesures physiques"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_design,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_design = value!;
                                    });
                                  },
                                ),
                                Text("Design"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_audiovisual,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_audiovisual = value!;
                                    });
                                  },
                                ),
                                Text("Audiovisuel"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_insurance,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_insurance = value!;
                                    });
                                  },
                                ),
                                Text("Assurance"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_bank,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_bank = value!;
                                    });
                                  },
                                ),
                                Text("Banque"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_accounting,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_accounting = value!;
                                    });
                                  },
                                ),
                                Text("Comptabilité"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_building,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_building = value!;
                                    });
                                  },
                                ),
                                Text("Bâtiment"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_public_works,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_public_works = value!;
                                    });
                                  },
                                ),
                                Text("Travaux publics"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_electronic,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_electronic = value!;
                                    });
                                  },
                                ),
                                Text("Electronique"),
                              ],
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_electrical_engineering,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_electrical_engineering = value!;
                                    });
                                  },
                                ),
                                Text("Electrotechnique"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_hotel,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_hotel = value!;
                                    });
                                  },
                                ),
                                Text("Hôtellerie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_tourism,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_tourism = value!;
                                    });
                                  },
                                ),
                                Text("Tourisme"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_mechanic,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_mechanic = value!;
                                    });
                                  },
                                ),
                                Text("Mécanique"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_automatism,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_automatism = value!;
                                    });
                                  },
                                ),
                                Text("Automatisme"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_metallic_constructions,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_metallic_constructions = value!;
                                    });
                                  },
                                ),
                                Text("Constructions métalliques"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_health,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_health = value!;
                                    });
                                  },
                                ),
                                Text("Santé"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_paramedic,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_paramedic = value!;
                                    });
                                  },
                                ),
                                Text("Paramédical"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_social,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_social = value!;
                                    });
                                  },
                                ),
                                Text("Social"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_marketing,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_marketing = value!;
                                    });
                                  },
                                ),
                                Text("Marketing"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_financial_management,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_financial_management = value!;
                                    });
                                  },
                                ),
                                Text("Gestion financière"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_energy,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_energy = value!;
                                    });
                                  },
                                ),
                                Text("Energie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_economy,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_economy = value!;
                                    });
                                  },
                                ),
                                Text("Economie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_human_sciences,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_human_sciences = value!;
                                    });
                                  },
                                ),
                                Text("Sciences humaines"),
                              ],
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_space_geometry,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_space_geometry = value!;
                                    });
                                  },
                                ),
                                Text("Géométrie dans l'espace"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_sociology,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_sociology = value!;
                                    });
                                  },
                                ),
                                Text("Sociologie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_material_resistance,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_material_resistance = value!;
                                    });
                                  },
                                ),
                                Text("Résistance des matériaux"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_acoustic,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_acoustic = value!;
                                    });
                                  },
                                ),
                                Text("Acoustique"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_road,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_road = value!;
                                    });
                                  },
                                ),
                                Text("Voirie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_architecture_history,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_architecture_history = value!;
                                    });
                                  },
                                ),
                                Text("Histoire de l'architecture"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_finance,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_finance = value!;
                                    });
                                  },
                                ),
                                Text("Finance"),
                              ],
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_taxation,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_taxation = value!;
                                    });
                                  },
                                ),
                                Text("Fiscalité"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_human_resources,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_human_resources = value!;
                                    });
                                  },
                                ),
                                Text("Ressources humaines"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_statistics,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_statistics = value!;
                                    });
                                  },
                                ),
                                Text("Statistiques"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_work_medicine,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_work_medicine = value!;
                                    });
                                  },
                                ),
                                Text("Médecine du travail"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_public_health,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_public_health = value!;
                                    });
                                  },
                                ),
                                Text("Santé publique"),
                              ],
                            ),

                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_surgical_specialities,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_surgical_specialities = value!;
                                    });
                                  },
                                ),
                                Text("Spécialités chirurgicales"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_medical_biology,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_medical_biology = value!;
                                    });
                                  },
                                ),
                                Text("Biologie médicale"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_psychiatry,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_psychiatry = value!;
                                    });
                                  },
                                ),
                                Text("Psychiatrie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_gynecologist,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_gynecologist = value!;
                                    });
                                  },
                                ),
                                Text("Gynécologie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_obstetrics_pediatrics,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_obstetrics_pediatrics = value!;
                                    });
                                  },
                                ),
                                Text("Obstétrique pédiatrique"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_anesthesiology,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_anesthesiology = value!;
                                    });
                                  },
                                ),
                                Text("Anesthésiologie"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_surgical_resuscitation,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_surgical_resuscitation = value!;
                                    });
                                  },
                                ),
                                Text("Réanimation chirurgicale"),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: secondarySubjectState_general_medicine,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      secondarySubjectState_general_medicine = value!;
                                    });
                                  },
                                ),
                                Text("Médecine générale"),
                              ],
                            ),
                          ],
                        )
                    )
                )
            )
        )
    );

  }

  Widget ClassePreparatoireLevel() {
    return Visibility(
        visible: classePreparatoireLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: classePreparatoireLevelState_first_year,
                        onChanged: (bool? value) {
                          setState(() {
                            classePreparatoireLevelState_first_year = value!;
                          });
                        },
                      ),
                      Text("1ère année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: classePreparatoireLevelState_second_year,
                        onChanged: (bool? value) {
                          setState(() {
                            classePreparatoireLevelState_second_year = value!;
                          });
                        },
                      ),
                      Text("2ème année"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget ButDutLevel() {
    return Visibility(
        visible: butDutLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: butDutLevelState_first_year,
                        onChanged: (bool? value) {
                          setState(() {
                            butDutLevelState_first_year = value!;
                          });
                        },
                      ),
                      Text("1ère année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: butDutLevelState_second_year,
                        onChanged: (bool? value) {
                          setState(() {
                            butDutLevelState_second_year = value!;
                          });
                        },
                      ),
                      Text("2ème année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: butDutLevelState_third_year,
                        onChanged: (bool? value) {
                          setState(() {
                            butDutLevelState_third_year = value!;
                          });
                        },
                      ),
                      Text("3ème année"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget BtsLevel() {
    return Visibility(
        visible: btsLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: btsLevelState_first_year,
                        onChanged: (bool? value) {
                          setState(() {
                            btsLevelState_first_year = value!;
                          });
                        },
                      ),
                      Text("1ère année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: btsLevelState_second_year,
                        onChanged: (bool? value) {
                          setState(() {
                            btsLevelState_second_year = value!;
                          });
                        },
                      ),
                      Text("2ème année"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget SchoolEngineeringLevel() {
    return Visibility(
        visible: engineeringLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: engineeringLevelState_first_year,
                        onChanged: (bool? value) {
                          setState(() {
                            engineeringLevelState_first_year = value!;
                          });
                        },
                      ),
                      Text("1ère année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: engineeringLevelState_second_year,
                        onChanged: (bool? value) {
                          setState(() {
                            engineeringLevelState_second_year = value!;
                          });
                        },
                      ),
                      Text("2ème année (Master 1)"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: engineeringLevelState_third_year,
                        onChanged: (bool? value) {
                          setState(() {
                            engineeringLevelState_third_year = value!;
                          });
                        },
                      ),
                      Text("3ème année (Master 2)"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget SchoolArchitectLevel() {
    return Visibility(
        visible: architectLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: architectLevelState_first_year,
                        onChanged: (bool? value) {
                          setState(() {
                            architectLevelState_first_year = value!;
                          });
                        },
                      ),
                      Text("1ère année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: architectLevelState_second_year,
                        onChanged: (bool? value) {
                          setState(() {
                            architectLevelState_second_year = value!;
                          });
                        },
                      ),
                      Text("2ème année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: architectLevelState_third_year,
                        onChanged: (bool? value) {
                          setState(() {
                            architectLevelState_third_year = value!;
                          });
                        },
                      ),
                      Text("3ème année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: architectLevelState_fourth_year,
                        onChanged: (bool? value) {
                          setState(() {
                            architectLevelState_fourth_year = value!;
                          });
                        },
                      ),
                      Text("4ème année (Master 1)"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: architectLevelState_fifth_year,
                        onChanged: (bool? value) {
                          setState(() {
                            architectLevelState_fifth_year = value!;
                          });
                        },
                      ),
                      Text("5ème année (Master 2)"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget SchoolCommercialLevel() {
    return Visibility(
        visible: commercialLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: commercialLevelState_first_year,
                        onChanged: (bool? value) {
                          setState(() {
                            commercialLevelState_first_year = value!;
                          });
                        },
                      ),
                      Text("1ère année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: commercialLevelState_second_year,
                        onChanged: (bool? value) {
                          setState(() {
                            commercialLevelState_second_year = value!;
                          });
                        },
                      ),
                      Text("2ème année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: commercialLevelState_third_year,
                        onChanged: (bool? value) {
                          setState(() {
                            commercialLevelState_third_year = value!;
                          });
                        },
                      ),
                      Text("3ème année"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: commercialLevelState_fourth_year,
                        onChanged: (bool? value) {
                          setState(() {
                            commercialLevelState_fourth_year = value!;
                          });
                        },
                      ),
                      Text("4ème année (Master 1)"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: commercialLevelState_fifth_year,
                        onChanged: (bool? value) {
                          setState(() {
                            commercialLevelState_fifth_year = value!;
                          });
                        },
                      ),
                      Text("5ème année (Master 2)"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget MedicalLevel() {
    return Visibility(
        visible: medicalLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: medicalLevelState_first_cycle,
                        onChanged: (bool? value) {
                          setState(() {
                            medicalLevelState_first_cycle = value!;
                          });
                        },
                      ),
                      Text("1er cycle(1,2 et 3ème année)"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: medicalLevelState_second_cycle,
                        onChanged: (bool? value) {
                          setState(() {
                            medicalLevelState_second_cycle = value!;
                          });
                        },
                      ),
                      Text("2ème cycle(4,5 et 6ème année)"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: medicalLevelState_third_cycle,
                        onChanged: (bool? value) {
                          setState(() {
                            medicalLevelState_third_cycle = value!;
                          });
                        },
                      ),
                      Text("3ème cycle(7,8,9,10,11 et 12ème année)"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Widget ArtisticLevel() {
    return Visibility(
        visible: artisticLevelState,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  //color: Colors.red,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState_graphics,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState_graphics = value!;
                          });
                        },
                      ),
                      Text("graphisme"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState_music,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState_music = value!;
                          });
                        },
                      ),
                      Text("musique"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState_animation,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState_animation = value!;
                          });
                        },
                      ),
                      Text("animation (3D, etc)"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState_cinema,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState_cinema = value!;
                          });
                        },
                      ),
                      Text("cinema"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState_theater,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState_theater = value!;
                          });
                        },
                      ),
                      Text("théâtre"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState_luxury,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState_luxury = value!;
                          });
                        },
                      ),
                      Text("luxe"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState_mode,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState_mode = value!;
                          });
                        },
                      ),
                      Text("mode"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState_multimedia,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState_multimedia = value!;
                          });
                        },
                      ),
                      Text("multimedia"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState_visual_communication,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState_visual_communication = value!;
                          });
                        },
                      ),
                      Text("communication visuelle"),
                      Checkbox(
                        checkColor: Colors.white,
                        value: artisticLevelState_arts,
                        onChanged: (bool? value) {
                          setState(() {
                            artisticLevelState_arts = value!;
                          });
                        },
                      ),
                      Text("arts"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

}

class CustomKeywords extends StatefulWidget {
  final Function(List) onCustomKeyWords;
  CustomKeywords(this.onCustomKeyWords);

  @override
  _CustomKeywordsState createState() => _CustomKeywordsState(this.onCustomKeyWords);
}


class _CustomKeywordsState extends State<CustomKeywords> {

  final Function(List) onCustomKeyWords;
  bool currentCustomKeywordStateIsOk = true;
  late TextEditingController customKeywordsController = TextEditingController();

  _CustomKeywordsState(this.onCustomKeyWords);

  @override
  void initState() {
    customKeywordsController.addListener(() {
      String status = checkCustomKeywords(customKeywordsController.text);
      if ("SUCCESS" != status){
        //debugPrint("DEBUG_LOG customKeywordsController 0");
        setState((){
          onCustomKeyWords(["customKeyWordsFailed",status]);
          currentCustomKeywordStateIsOk = false;
        });
      } else {
        //debugPrint("DEBUG_LOG customKeywordsController 1");
        List result = addKeyWords(customKeywordsController.text);
        setState((){
          onCustomKeyWords(result);
          currentCustomKeywordStateIsOk = true;
        });
      };
    });
    super.initState();
  }

  @override
  void dispose(){
    customKeywordsController.dispose();
    super.dispose();
  }

  String checkCustomKeywords(String controllerText){

    if (controllerText.isNotEmpty){
      if(!controllerText.contains(",")){
        return "Tu dois séparer chaque mot-clé par une virgule.";
      }

      List listOfKeywords = controllerText.trim().split(",");

      if (listOfKeywords.length > 3){
        return "Tu ne peux pas dépasser 3 mots-clés.";
      }

      for (int i=0;i<listOfKeywords.length;i++){
        List keywordComposition = listOfKeywords[i].trim().split(" ");
        if (keywordComposition.length > 3){
          int index = i + 1;
          return i==0 ? "Ton 1er mot-clé ne peut pas être composé de plus de 3 éléments." : "Ton $index"+"eme mot-clé ne peut pas être composé de plus de 3 éléments.";
        }
      }
    }

    return "SUCCESS";
  }

  List addKeyWords(String keywordsInput){

    final listOfKeyWords = keywordsInput.split(",");
    List tmpListOfKeyWords = [];

    for(int i=0; i<listOfKeyWords.length;i++)
    {
      var keyword = removeDiacritics(listOfKeyWords.elementAt(i).trim());
      List keywordComposition = keyword.split(" ");
      String cleanedKeyword = "";

      if (keywordComposition.length > 1){
        keywordComposition.forEach((element) {
          if (keywordComposition.last != element){
            cleanedKeyword += element + "_";
          }else {
            cleanedKeyword += element;
          }

        });
      }else {
        cleanedKeyword = keywordComposition.first;
      }

      if (cleanedKeyword.isNotEmpty){
        tmpListOfKeyWords.add(cleanedKeyword);
      }
    }

    return tmpListOfKeyWords;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0, right: 8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                  offset: Offset(0, 3)
              ),
            ]
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 4,
                              offset: Offset(0, 3)
                          ),
                        ]
                    ),
                    child: TextField(
                      controller: customKeywordsController,
                      decoration: InputDecoration(
                        hintText: "Exemple: Cuisine, Jardinage, Java, C++",
                        hintMaxLines: 2,
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic
                        ),
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {

                  },
                  child: currentCustomKeywordStateIsOk ? Icon(Icons.check) : Icon(Icons.block_flipped),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    primary: currentCustomKeywordStateIsOk ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}