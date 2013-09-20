// MESSAGE KEYCODE_REQUEST PACKING

#define MAVLINK_MSG_ID_KEYCODE_REQUEST 159

typedef struct __mavlink_keycode_request_t
{
 uint8_t device_name; ///< name of device: can be one of following values: GSTABI, GMOTION
} mavlink_keycode_request_t;

#define MAVLINK_MSG_ID_KEYCODE_REQUEST_LEN 1
#define MAVLINK_MSG_ID_159_LEN 1



#define MAVLINK_MESSAGE_INFO_KEYCODE_REQUEST { \
	"KEYCODE_REQUEST", \
	1, \
	{  { "device_name", NULL, MAVLINK_TYPE_UINT8_T, 0, 0, offsetof(mavlink_keycode_request_t, device_name) }, \
         } \
}


/**
 * @brief Pack a keycode_request message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param device_name name of device: can be one of following values: GSTABI, GMOTION
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_keycode_request_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
						       uint8_t device_name)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[1];
	_mav_put_uint8_t(buf, 0, device_name);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, 1);
#else
	mavlink_keycode_request_t packet;
	packet.device_name = device_name;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, 1);
#endif

	msg->msgid = MAVLINK_MSG_ID_KEYCODE_REQUEST;
	return mavlink_finalize_message(msg, system_id, component_id, 1, 99);
}

/**
 * @brief Pack a keycode_request message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message was sent over
 * @param msg The MAVLink message to compress the data into
 * @param device_name name of device: can be one of following values: GSTABI, GMOTION
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_keycode_request_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
							   mavlink_message_t* msg,
						           uint8_t device_name)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[1];
	_mav_put_uint8_t(buf, 0, device_name);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, 1);
#else
	mavlink_keycode_request_t packet;
	packet.device_name = device_name;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, 1);
#endif

	msg->msgid = MAVLINK_MSG_ID_KEYCODE_REQUEST;
	return mavlink_finalize_message_chan(msg, system_id, component_id, chan, 1, 99);
}

/**
 * @brief Encode a keycode_request struct into a message
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param keycode_request C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_keycode_request_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_keycode_request_t* keycode_request)
{
	return mavlink_msg_keycode_request_pack(system_id, component_id, msg, keycode_request->device_name);
}

/**
 * @brief Send a keycode_request message
 * @param chan MAVLink channel to send the message
 *
 * @param device_name name of device: can be one of following values: GSTABI, GMOTION
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_keycode_request_send(mavlink_channel_t chan, uint8_t device_name)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
	char buf[1];
	_mav_put_uint8_t(buf, 0, device_name);

	_mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_KEYCODE_REQUEST, buf, 1, 99);
#else
	mavlink_keycode_request_t packet;
	packet.device_name = device_name;

	_mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_KEYCODE_REQUEST, (const char *)&packet, 1, 99);
#endif
}

#endif

// MESSAGE KEYCODE_REQUEST UNPACKING


/**
 * @brief Get field device_name from keycode_request message
 *
 * @return name of device: can be one of following values: GSTABI, GMOTION
 */
static inline uint8_t mavlink_msg_keycode_request_get_device_name(const mavlink_message_t* msg)
{
	return _MAV_RETURN_uint8_t(msg,  0);
}

/**
 * @brief Decode a keycode_request message into a struct
 *
 * @param msg The message to decode
 * @param keycode_request C-struct to decode the message contents into
 */
static inline void mavlink_msg_keycode_request_decode(const mavlink_message_t* msg, mavlink_keycode_request_t* keycode_request)
{
#if MAVLINK_NEED_BYTE_SWAP
	keycode_request->device_name = mavlink_msg_keycode_request_get_device_name(msg);
#else
	memcpy(keycode_request, _MAV_PAYLOAD(msg), 1);
#endif
}
