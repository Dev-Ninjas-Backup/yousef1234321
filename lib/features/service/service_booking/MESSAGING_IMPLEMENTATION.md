# Service Messaging Implementation Guide

## Overview
The service messaging feature uses the **Private Chat API** with real-time WebSocket (Socket.IO) connections for instant messaging between garage owners and customers.

## Architecture

### Components

#### 1. **ServiceBookingController** 
- Manages WebSocket connection lifecycle
- Handles message sending and receiving
- Manages conversation history via REST API
- Formats messages for UI display

#### 2. **ServiceMessage Widget**
- Displays real-time chat interface
- Shows connection status
- Supports file attachment visualization
- Optimized message rendering

## API Integration

### Base URL
```
https://domainname/pv/message
```

### Authentication
All requests use Bearer JWT token from `ApiClient.to.token`

## Key Features Implemented

### 1. WebSocket Connection
**Namespace**: `/pv/message`

**Events Handled**:
- `private:success` - Authentication confirmation
- `private:new_message` - Incoming messages (real-time)
- `private:error` - Connection errors
- `disconnect` - Connection lost

**Example Usage**:
```dart
controller.initializeChat(recipientId);
```

### 2. Message Loading

**HTTP GET** `/private-chat`
- Loads all conversations with last message
- Called automatically on chat initialization

**HTTP GET** `/private-chat/:conversationId`
- Loads full message history for a conversation
- Sorts messages by `createdAt` ascending

### 3. Message Sending

#### Text-Only Messages (Via WebSocket)
```dart
socket.emit('private:send_message', {
  'recipientId': 'user-uuid',
  'content': 'Hello!',
  'replyToMessageId': null,  // Optional
});
```

#### Messages with Files (Via HTTP)
```dart
controller.sendMessage(filePaths: ['path/to/file1.jpg', 'path/to/file2.pdf']);
```

**Endpoint**: `POST /private-chat/send-message/:recipientId`
- Supports up to 5 files
- Content-Type: `multipart/form-data`

### 4. Real-Time Updates
- Messages arrive via `private:new_message` event
- Automatically added to chat interface
- Both sender and receiver get updates

## Message Object Structure

```json
{
  "id": "uuid",
  "content": "Hello world",
  "files": [
    "https://cdn.example.com/uploads/image.jpg"
  ],
  "createdAt": "2025-12-24T10:00:00.000Z",
  "sender": {
    "id": "user-uuid",
    "fullName": "Ahmed Ali",
    "profilePhoto": "https://cdn.../photo.jpg"
  },
  "replyToMessageId": null
}
```

## Implementation Details

### Controller Properties

```dart
var messages = <Map<String, dynamic>>[].obs;        // Message list
var isConnected = false.obs;                         // WebSocket connection status
var recipientId = RxnString();                       // Current chat recipient
var conversationId = RxnString();                    // Current conversation ID
TextEditingController textController;                // Message input field
IO.Socket? socket;                                   // WebSocket socket instance
```

### Key Methods

#### `initializeChat(String? recId)`
- Initializes chat with a recipient
- Connects to WebSocket
- Loads message history

#### `sendMessage({List<String>? filePaths})`
- Sends text message via WebSocket if no files
- Sends with files via HTTP if files provided
- Clears input field after sending

#### `_formatTime(String? dateTimeString)`
- Converts ISO datetime to 12-hour format
- Fallback to current time if parsing fails

#### `_addMessageToList(Map<String, dynamic> messageData, {required bool isUser})`
- Adds received message to observable list
- Handles both user and recipient messages

## UI Components

### Connection Status Indicator
```dart
Obx(
  () => Text(
    controller.isConnected.value ? "Active Now" : "Connecting...",
    style: getTextStyle(
      color: controller.isConnected.value ? Colors.green : Colors.orange,
    ),
  ),
)
```

### Message Bubble
- Different background colors for sender/receiver
- Rounded corners with asymmetric radius
- Shows timestamp and delivery status (checkmarks for sent messages)
- Displays file previews for image attachments

### Input Field
- Text input with character count (optional)
- Attach file button (ready for file picker integration)
- Send button with connection status indication

## Error Handling

### WebSocket Disconnection
- Automatically shows "Connecting..." status
- Prevents sending until reconnected
- Logs errors for debugging

### Failed Message Sending
- Text messages fail silently if socket not connected
- File uploads show error in console
- Consider adding user-facing error UI

### API Errors
- Caught and logged in console
- Conversation history loading fails gracefully

## Dependencies

### Added Packages
- `socket_io_client: ^2.0.3` - WebSocket client
- `intl: ^0.19.0` - Date/time formatting

## Usage Example

### Launching the Messaging Screen
```dart
// In your navigation code
Get.to(
  ServiceMessage(
    recipientId: garageOwnerId, // Pass the recipient's user ID
  ),
);
```

### Sending a Message
```dart
// Text message
controller.textController.text = "Hello!";
controller.sendMessage();

// Message with files (when file picker is integrated)
controller.sendMessage(
  filePaths: ['/path/to/file1.jpg', '/path/to/file2.pdf']
);
```

## Future Enhancements

1. **File Picker Integration**
   - Integrate `file_picker` package
   - Support multiple file selection
   - Show upload progress

2. **Read Receipts**
   - Emit "read" event when message is viewed
   - Display "read" indicator

3. **Typing Indicators**
   - Emit typing event while composing
   - Show "user is typing..." indicator

4. **Message Search**
   - Search through conversation history
   - Filter by date or sender

5. **Image Gallery**
   - Show all shared images in a gallery view
   - Support image zooming

6. **Reply to Message**
   - Implement message reply functionality
   - Show context quote in message

## Troubleshooting

### WebSocket Not Connecting
- Check JWT token validity
- Verify API base URL is correct
- Check network connectivity
- Review browser console for errors

### Messages Not Appearing
- Verify recipient ID is correct
- Check if conversation exists
- Ensure WebSocket is connected
- Review API response in network tab

### File Upload Failing
- Check file size limits (backend may have limits)
- Verify file format is supported
- Check internet connection

## Testing Checklist

- [ ] WebSocket connects on app launch
- [ ] Previous messages load on conversation open
- [ ] Text messages send and appear in real-time
- [ ] Incoming messages display correctly
- [ ] Connection status shows accurately
- [ ] File previews display for image files
- [ ] Send button disabled when not connected
- [ ] Timestamp formatting is correct
- [ ] Profile photos load from sender data
- [ ] Conversation scrolls to latest message

