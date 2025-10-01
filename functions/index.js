const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// send notification when a new message is created in our firestore db
exports.sendNotificationMessage = functions.firestore.document('chatrooms/{chatroomId}/messages/{messageId}').onCreate(async (snapshot, context) => {
    const message = snapshot.data();
    try {
        const receiverDoc = await admin.firestore().collection('users').doc(message.receiverID).get();
        if (!receiverDoc.exists) {
            console.log('No such receiver!');
            return null;
        }

        const receiverData = receiverDoc.data();
        const token = receiverData.fcmToken;

        if (!token) {
            console.log('No token for user, cannot send notification');
            return null;
        }

        const messagePayload = {
            token: token,
            notification: {
                title: message.senderEmail,
                body: message.message,
            },
            android: {
                notification: {
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            },
            apns: {
                payloads: {
                    aps: {
                        category: 'FLUTTER_NOTIFICATION_CLICK'
                    }
                }
            }
        };

        const response = await admin.messaging().send(messagePayload);
        console.log('Notification sent successfully: ', response);
        return response;
    } catch (error) {
        console.error('Detailed error: ', error);
        if (error.code && error.message) {
            console.error('Error code: ', error.code);
            console.error('Error message: ', error.message);
        }
        throw new Error('Failed to send notification');
    }
})