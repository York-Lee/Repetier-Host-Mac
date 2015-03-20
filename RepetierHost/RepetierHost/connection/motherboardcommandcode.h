#ifndef MOTHERBOARDCOMMANDCODE
#define MOTHERBOARDCOMMANDCODE

//namespace ToolCommandcode
//{
	//enum ToolCommandCode
    typedef NS_OPTIONS(NSUInteger, ToolCommandCode)
	{
		VERSION = 0,                // (0),
		INIT = 1,                   // (1),
		GET_TEMP = 2,               // (2),
		SET_TEMP = 3,               // (3),
		SET_MOTOR_1_PWM = 4,        // (4),
		SET_MOTOR_2_PWM = 5,        // (5),
		SET_MOTOR_1_RPM = 6,        // (6),
		SET_MOTOR_2_RPM = 7,        // (7),
		SET_MOTOR_1_DIR = 8,        // (8),
		SET_MOTOR_2_DIR = 9,        // (9),
		TOGGLE_MOTOR_1 = 10,        // (10),
		TOGGLE_MOTOR_2 = 11,        // (11),
		TOGGLE_FAN = 12,            // (12),
		TOGGLE_VALVE = 13,          // (13),
		SET_SERVO_1_POS = 14,       // (14),
		SET_SERVO_2_POS = 15,       // (15),
		FILAMENT_STATUS = 16,       // (16),
		GET_MOTOR_1_RPM = 17,       // (17),
		GET_MOTOR_2_RPM = 18,       // (18),
		GET_MOTOR_1_PWM = 19,       // (19),
		GET_MOTOR_2_PWM = 20,       // (20),
		SELECT_TOOL = 21,           // (21),
		IS_TOOL_READY = 22,         // (22),
		READ_FROM_EEPROM = 25,      // (25),
		WRITE_TO_EEPROM = 26,       // (26),
		TOGGLE_ABP = 27,            // (27),
		GET_PLATFORM_TEMP = 30,     // (30),
		SET_PLATFORM_TEMP = 31,     // (31),
		GET_SP = 32,                // (32),
		GET_PLATFORM_SP = 33,       // (33),
		GET_BUILD_NAME = 34,        // (34),
		IS_PLATFORM_READY = 35,     // (35),
		GET_TOOL_STATUS = 36,       // (36),
		GET_PID_STATE = 37,         // (37);
	};
//}

//namespace MotherboardCommandCode
//{
    //enum MotherboardCommandCode
    typedef NS_OPTIONS(NSUInteger, MotherboardCommandCode)
    {
        MotherboardCommandCode_VERSION = 0,
        MotherboardCommandCode_INIT = 1,
        GET_BUFFER_SIZE = 2,
        CLEAR_BUFFER = 3,
        GET_POSITION = 4,
        GET_RANGE = 5,
        SET_RANGE = 6,
        ABORT = 7,
        PAUSE = 8,
        PROBE = 9,
        TOOL_QUERY = 10,
        IS_FINISHED = 11,
        READ_EEPROM = 12,
        WRITE_EEPROM = 13,

        CAPTURE_TO_FILE = 14,
        END_CAPTURE = 15,
        PLAYBACK_CAPTURE = 16,

        RESET = 17,

        NEXT_FILENAME = 18,
        MotherboardCommandCode_GET_BUILD_NAME = 20,            // Get the build name
        GET_POSITION_EXT = 21,
        EXTENDED_STOP = 22,
        GET_BUILD_STAT = 24,

        BUILD_START_NOTIFICATION = 153, // "Notify the bot this is an object build, and what it is called"),
        BUILD_END_NOTIFICATION = 154,   // "Notify the bot object build is complete."),
        QUEUE_POINT_NEW_EXT = 155,
        SET_ACCELERATION_TOGGLE = 156,

        GET_COMMUNICATION_STATS = 25,

        // QUEUE_POINT_INC(128) obsolete
        QUEUE_POINT_ABS = 129,
        SET_POSITION = 130,
        FIND_AXES_MINIMUM = 131,
        FIND_AXES_MAXIMUM = 132,
        DELAY = 133,
        CHANGE_TOOL = 134,
        WAIT_FOR_TOOL = 135,
        TOOL_COMMAND = 136,
        ENABLE_AXES = 137,
        QUEUE_POINT_EXT = 139,
        SET_POSITION_EXT = 140,
        WAIT_FOR_PLATFORM = 141,
        QUEUE_POINT_NEW = 142,

        STORE_HOME_POSITIONS = 143,
        RECALL_HOME_POSITIONS = 144,

        SET_STEPPER_REFERENCE_POT = 145,// "set the digital pot for stepper power reference"),
        SET_LED_STRIP_COLOR = 146,      // "set an RGB value to blink the leds, optional blink trigger"),
        SET_BEEP = 147,                 // "set a beep frequency and length"),

        PAUSE_FOR_BUTTON = 148,         // "Wait until a user button push is recorded"),
        DISPLAY_MESSAGE = 149,          // "Display a user message on the machine display"),
        SET_BUILD_PERCENT = 150,        // "Manually override Build % info"),
        QUEUE_SONG = 151,               // "Trigger a song stored by by ID on the machine"),
        RESET_TO_FACTORY = 152,         // "Reset onboard preferences to the factory settings");
    };
//}

#endif // MOTHERBOARDCOMMANDCODE

