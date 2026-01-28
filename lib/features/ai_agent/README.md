# POS AI Assistant - Setup & Usage Guide

## ✅ Status: Ready to Use

The AI Assistant has been successfully integrated into your POS app as a **bottom navigation item**. It appears alongside the Sales dashboard.

---

## 🚀 How to Use

### Accessing the AI Assistant

1. **Open the app** and go to the **Dashboard**
2. Look at the **bottom navigation bar** - you'll see two items:
   - **Sales** (Dashboard) - Index 0
   - **AI Agent** (Robot icon 🤖) - Index 1
3. **Tap "AI Agent"** to open the chat interface

### Asking Questions

The AI Agent specializes in helping with POS-related topics:

✅ **What you CAN ask:**

- "How do I create a new order?"
- "Show me how to manage inventory"
- "How do I process a refund?"
- "Where can I find reports?"
- "How to add a new product?"
- "How to manage customer profiles?"
- "How to apply discounts?"

❌ **What you CANNOT ask:**

- General trivia or knowledge questions
- Weather, news, entertainment
- Coding or technical questions
- Personal advice unrelated to POS
- Questions about other apps

---

## 🔑 API Key Configuration

### Verify Your API Key is Set

Your API key is already configured in the `.env` file:

```
GEMINI_API_KEY=AIzaSyCP_C92Kn89l0Re4WNZ0nEecjU1FerGrkI
```

✅ **This is already done!** The app will automatically use this key.

### If You Need to Change It

1. Open `.env` file in the project root
2. Replace the value after `GEMINI_API_KEY=` with your own key
3. Save the file
4. Restart the app

---

## 🔧 Troubleshooting

### "API Key Not Configured" Error

**Solution:** The app couldn't load the `.env` file.

- Make sure the `.env` file exists in the project root
- Verify `GEMINI_API_KEY=` has a valid value
- Restart the app

### "Invalid API Key" Error

**Solution:** The API key is incorrect or expired.

- Go to https://aistudio.google.com/app/apikey
- Create a new API key
- Update the value in `.env`
- Restart the app

### "Quota Exceeded" Error

**Solution:** Free tier limit reached.

- Free tier: 15 requests/minute, 1,500 requests/day
- Wait a while and try again
- Consider upgrading to a paid plan for higher limits

### "Network Error" / No Response

**Solution:** Internet connection issue.

- Check your internet connection
- Ensure your device can access Google's servers
- Try again in a few moments

---

## 📊 Free Tier Limits

Google Gemini API Free Tier:

- **15 requests per minute** (RPM)
- **1,500 requests per day** (RPD)
- **1 million tokens per minute** (TPM)

This is perfect for a POS app assistant!

---

## 🏗️ Architecture

### Files Structure

```
lib/features/ai_agent/
├── model/
│   └── chat_message_model.dart          # Chat message data
├── repository/
│   └── ai_agent_repository.dart         # Gemini API integration
├── viewmodel/
│   └── ai_agent_viewmodel.dart          # State management
└── view/
    ├── pages/
    │   └── ai_chat_page.dart            # Chat UI (embedded in dashboard)
    └── widgets/
        ├── chat_bubble.dart             # Message bubble widget
        └── chat_input.dart              # Input & suggestions widget
```

### Integration Points

1. **Dashboard Page** - Shows AI Agent when bottom nav index = 1
2. **Bottom Nav Bar** - Two items: Sales (0) and AI Agent (1)
3. **Gemini API** - Handles all AI responses

---

## 🔐 Safety & Guidelines

The AI is configured with:

- **System Prompt** - Restricts responses to POS topics only
- **Safety Settings** - Blocks harmful content
- **Token Limits** - Max 1024 tokens per response to keep responses concise
- **Temperature 0.7** - Balanced creativity and consistency

---

## 📝 Development Notes

### Adding More Commands

To extend AI capabilities, modify the system instruction in:

```dart
lib/features/ai_agent/repository/ai_agent_repository.dart
```

Look for the `_systemInstruction` constant and add new topics.

### Debugging

The app logs all AI operations to the console (debug mode):

- API initialization
- Message sending
- Responses received
- Errors encountered

Check the console output when testing.

---

## ✨ Features

- ✅ Real-time chat interface
- ✅ Message history within session
- ✅ Clear chat history button
- ✅ Quick suggestion chips
- ✅ Typing indicator while AI responds
- ✅ Error handling with user-friendly messages
- ✅ Smooth animations and transitions
- ✅ Responsive design

---

**Ready to go!** Your POS AI Assistant is fully configured and working. Just start asking questions! 🚀
