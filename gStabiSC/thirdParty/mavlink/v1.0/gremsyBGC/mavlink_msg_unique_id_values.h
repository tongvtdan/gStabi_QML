// MESSAGE UNIQUE_ID_VALUES PACKING

#define MAVLINK_MSG_ID_UNIQUE_ID_VALUES 158

typedef struct __mavlink_unique_id_values_t
{
 uint16_t unique_id_0; ///< value of U_ID_15:0 register
 uint16_t unique_id_1; ///< value of U_ID_31:16 register
 uint16_t unique_id_2; ///< value of U_ID_47:32 register
 uint16_t unique_id_3; ///< value of U_ID_63:48 register
 uint16_t unique_id_4; ///< value of U_ID_79:64 register
 uint16_t unique_id_5; ///< value of U_ID_95:80 register
 uint8_t device_name; ///< name of device: can be one of following values: GSTABI, GMOTION
} mavlink_unique_id_values_t;

#define MAVLINK_MSG_ID_UNIQUE_ID_VALUES_LEN 13
#define MAVLINK_MSG_ID_158_LEN 13



#define MAVLINK_MESSAGE_INFO_UNIQUE_ID_VALUES { \
	"UNIQUE_ID_VALUES", \
	7, \
	{  { "unique_id_0", NULL, MAVLINK_TYPE_UINT16_T, 0, 0, offsetof(mavlink_unique_id_values_t, unique_id_0) }, \
         { "unique_id_1", NULL, MAVLINK_TYPE_UINT16_T, 0, 2, offsetof(mavlink_unique_id_values_t, unique_id_1) }, \
         { "unique_id_2", NULL, MAVLINK_TYPE_UINT16_T, 0, 4, offsetof(mavlink_unique_id_values_t, unique_id_2) }, \
         { "unique_id_3", NULL, MAVLINK_TYPE_UINT16_T, 0, 6, offsetof(mavlink_unique_id_values_t, unique_id_3) }, \
         { "unique_id_4", NULL, MAVLINK_TYPE_UINT16_T, 0, 8, offsetof(mavlink_unique_id_values_t, unique_id_4) }, \
         { "unique_id_5", NULL, MAVLINK_TYPE_UINT16_T, 0, 10, offsetof(mavlink_unique_id_values_t, unique_id_5) }, \
         { "device_name", NULL, MAVLINK_TYPE_UINT8_T, 0, 12, offsetof(mavlink_unique_id_values_t, device_name) }, \
         } \
}


/**
 * @brief Pack a unique_id_values message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param device_name name of device: can be one of following values: GSTABI, GMOTION
 * @param unique_id_0 value of U_ID_15:0 register
 * @param unique_id_1 value of U_ID_31:16 register
 * @param unique_id_2 value of U_ID_47:32 register
 * @param unique_id_3 value of U_ID_63:48 register
 * @param unique_id_4 value of U_ID_79:64 register
 * @param unique_id_5 value of U_ID_95:80 register
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_unique_id_values_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
						       uint8_t device_name, uint16_t unique_id_0, uint16_t unique_id_1, uint16_t unique_id_2, uint16_t unique_id_3, uint16_t unique_id_4, uint16_t unique_id_5)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[13];
	_mav_put_uint16_t(buf, 0, unique_id_0);
	_mav_put_uint16_t(buf, 2, unique_id_1);
	_mav_put_uint16_t(buf, 4, unique_id_2);
	_mav_put_uint16_t(buf, 6, unique_id_3);
	_mav_put_uint16_t(buf, 8, unique_id_4);
	_mav_put_uint16_t(buf, 10, unique_id_5);
	_mav_put_uint8_t(buf, 12, device_name);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, 13);
#else
	mavlink_unique_id_values_t packet;
	packet.unique_id_0 = unique_id_0;
	packet.unique_id_1 = unique_id_1;
	packet.unique_id_2 = unique_id_2;
	packet.unique_id_3 = unique_id_3;
	packet.unique_id_4 = unique_id_4;
	packet.unique_id_5 = unique_id_5;
	packet.device_name = device_name;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, 13);
#endif

	msg->msgid = MAVLINK_MSG_ID_UNIQUE_ID_VALUES;
	return mavlink_finalize_message(msg, system_id, component_id, 13, 120);
}

/**
 * @brief Pack a unique_id_values message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message was sent over
 * @param msg The MAVLink message to compress the data into
 * @param device_name name of device: can be one of following values: GSTABI, GMOTION
 * @param unique_id_0 value of U_ID_15:0 register
 * @param unique_id_1 value of U_ID_31:16 register
 * @param unique_id_2 value of U_ID_47:32 register
 * @param unique_id_3 value of U_ID_63:48 register
 * @param unique_id_4 value of U_ID_79:64 register
 * @param unique_id_5 value of U_ID_95:80 register
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_unique_id_values_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
							   mavlink_message_t* msg,
						           uint8_t device_name,uint16_t unique_id_0,uint16_t unique_id_1,uint16_t unique_id_2,uint16_t unique_id_3,uint16_t unique_id_4,uint16_t unique_id_5)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[13];
	_mav_put_uint16_t(buf, 0, unique_id_0);
	_mav_put_uint16_t(buf, 2, unique_id_1);
	_mav_put_uint16_t(buf, 4, unique_id_2);
	_mav_put_uint16_t(buf, 6, unique_id_3);
	_mav_put_uint16_t(buf, 8, unique_id_4);
	_mav_put_uint16_t(buf, 10, unique_id_5);
	_mav_put_uint8_t(buf, 12, device_name);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, 13);
#else
	mavlink_unique_id_values_t packet;
	packet.unique_id_0 = unique_id_0;
	packet.unique_id_1 = unique_id_1;
	packet.unique_id_2 = unique_id_2;
	packet.unique_id_3 = unique_id_3;
	packet.unique_id_4 = unique_id_4;
	packet.unique_id_5 = unique_id_5;
	packet.device_name = device_name;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, 13);
#endif

	msg->msgid = MAVLINK_MSG_ID_UNIQUE_ID_VALUES;
	return mavlink_finalize_message_chan(msg, system_id, component_id, chan, 13, 120);
}

/**
 * @brief Encode a unique_id_values struct into a message
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param unique_id_values C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_unique_id_values_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_unique_id_values_t* unique_id_values)
{
	return mavlink_msg_unique_id_values_pack(system_id, component_id, msg, unique_id_values->device_name, unique_id_values->unique_id_0, unique_id_values->unique_id_1, unique_id_values->unique_id_2, unique_id_values->unique_id_3, unique_id_values->unique_id_4, unique_id_values->unique_id_5);
}

/**
 * @brief Send a unique_id_values message
 * @param chan MAVLink channel to send the message
 *
 * @param device_name name of device: can be one of following values: GSTABI, GMOTION
 * @param unique_id_0 value of U_ID_15:0 register
 * @param unique_id_1 value of U_ID_31:16 register
 * @param unique_id_2 value of U_ID_47:32 register
 * @param unique_id_3 value of U_ID_63:48 register
 * @param unique_id_4 value of U_ID_79:64 register
 * @param unique_id_5 value of U_ID_95:80 register
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_unique_id_values_send(mavlink_channel_t chan, uint8_t device_name, uint16_t unique_id_0, uint16_t unique_id_1, uint16_t unique_id_2, uint16_t unique_id_3, uint16_t unique_id_4, uint16_t unique_id_5)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[13];
	_mav_put_uint16_t(buf, 0, unique_id_0);
	_mav_put_uint16_t(buf, 2, unique_id_1);
	_mav_put_uint16_t(buf, 4, unique_id_2);
	_mav_put_uint16_t(buf, 6, unique_id_3);
	_mav_put_uint16_t(buf, 8, unique_id_4);
	_mav_put_uint16_t(buf, 10, unique_id_5);
	_mav_put_uint8_t(buf, 12, device_name);

	_mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_UNIQUE_ID_VALUES, buf, 13, 120);
#else
	mavlink_unique_id_values_t packet;
	packet.unique_id_0 = unique_id_0;
	packet.unique_id_1 = unique_id_1;
	packet.unique_id_2 = unique_id_2;
	packet.unique_id_3 = unique_id_3;
	packet.unique_id_4 = unique_id_4;
	packet.unique_id_5 = unique_id_5;
	packet.device_name = device_name;

	_mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_UNIQUE_ID_VALUES, (const char *)&packet, 13, 120);
#endif
}

#endif

// MESSAGE UNIQUE_ID_VALUES UNPACKING


/**
 * @brief Get field device_name from unique_id_values message
 *
 * @return name of device: can be one of following values: GSTABI, GMOTION
 */
static inline uint8_t mavlink_msg_unique_id_values_get_device_name(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  12);
}

/**
 * @brief Get field unique_id_0 from unique_id_values message
 *
 * @return value of U_ID_15:0 register
 */
static inline uint16_t mavlink_msg_unique_id_values_get_unique_id_0(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint16_t(msg,  0);
}

/**
 * @brief Get field unique_id_1 from unique_id_values message
 *
 * @return value of U_ID_31:16 register
 */
static inline uint16_t mavlink_msg_unique_id_values_get_unique_id_1(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint16_t(msg,  2);
}

/**
 * @brief Get field unique_id_2 from unique_id_values message
 *
 * @return value of U_ID_47:32 register
 */
static inline uint16_t mavlink_msg_unique_id_values_get_unique_id_2(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint16_t(msg,  4);
}

/**
 * @brief Get field unique_id_3 from unique_id_values message
 *
 * @return value of U_ID_63:48 register
 */
static inline uint16_t mavlink_msg_unique_id_values_get_unique_id_3(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint16_t(msg,  6);
}

/**
 * @brief Get field unique_id_4 from unique_id_values message
 *
 * @return value of U_ID_79:64 register
 */
static inline uint16_t mavlink_msg_unique_id_values_get_unique_id_4(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint16_t(msg,  8);
}

/**
 * @brief Get field unique_id_5 from unique_id_values message
 *
 * @return value of U_ID_95:80 register
 */
static inline uint16_t mavlink_msg_unique_id_values_get_unique_id_5(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint16_t(msg,  10);
}

/**
 * @brief Decode a unique_id_values message into a struct
 *
 * @param msg The message to decode
 * @param unique_id_values C-struct to decode the message contents into
 */
static inline void mavlink_msg_unique_id_values_decode(const mavlink_message_t* msg, mavlink_unique_id_values_t* unique_id_values)
{
#if MAVLINK_NEED_BYTE_SWAP
	unique_id_values->unique_id_0 = mavlink_msg_unique_id_values_get_unique_id_0(msg);
	unique_id_values->unique_id_1 = mavlink_msg_unique_id_values_get_unique_id_1(msg);
	unique_id_values->unique_id_2 = mavlink_msg_unique_id_values_get_unique_id_2(msg);
	unique_id_values->unique_id_3 = mavlink_msg_unique_id_values_get_unique_id_3(msg);
	unique_id_values->unique_id_4 = mavlink_msg_unique_id_values_get_unique_id_4(msg);
	unique_id_values->unique_id_5 = mavlink_msg_unique_id_values_get_unique_id_5(msg);
	unique_id_values->device_name = mavlink_msg_unique_id_values_get_device_name(msg);
#else
	memcpy(unique_id_values, _MAV_PAYLOAD(msg), 13);
#endif
}
