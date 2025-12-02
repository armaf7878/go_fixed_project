// src/components/Chatbot.jsx

import React, { useState, useRef, useEffect } from 'react';

const Chatbot = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState([
    { text: 'Xin chào! Tôi là trợ lý ảo của Mechanic. Tôi có thể giúp gì cho bạn về sản phẩm và dịch vụ?', sender: 'bot' }
  ]);
  const [inputValue, setInputValue] = useState('');
  const [isLoading, setIsLoading] = useState(false); // Thêm state cho loading
  const messagesEndRef = useRef(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const handleToggle = () => {
    setIsOpen(!isOpen);
  };

  const handleInputChange = (e) => {
    setInputValue(e.target.value);
  };

  const handleSendMessage = async () => {
    if (inputValue.trim() === '' || isLoading) return;

    const userMessage = { text: inputValue, sender: 'user' };
    setMessages(prev => [...prev, userMessage]);
    setInputValue('');
    setIsLoading(true);

    try {
      // Gọi API backend
      const response = await fetch('https://backend-tmdt.onrender.com/api/chat/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ question: userMessage.text }),
      });

      if (!response.ok) {
        throw new Error('Lỗi kết nối API');
      }

      const data = await response.json();
      const botMessage = { text: data.answer || 'Xin lỗi, tôi chưa hiểu rõ. Hãy thử hỏi lại nhé!', sender: 'bot' };

      setMessages(prev => [...prev, botMessage]);
    } catch (error) {
      console.error('Lỗi API:', error);
      const errorMessage = { text: 'Xin lỗi, có lỗi xảy ra. Vui lòng thử lại sau!', sender: 'bot' };
      setMessages(prev => [...prev, errorMessage]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="fixed z-50 font-sans bottom-4 right-4">
      {isOpen ? (
        <div className="flex flex-col bg-gray-900 border border-gray-700 rounded-lg shadow-2xl w-80 h-96">
          {/* Header */}
          <div className="flex items-center justify-between p-4 text-white rounded-t-lg bg-gradient-to-r from-orange-600 to-red-600">
            <div className="flex items-center space-x-2">
              {/* Icon Headset */}
              <svg xmlns="http://www.w3.org/2000/svg" className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192L5.636 18.364M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-5 0a4 4 0 11-8 0 4 4 0 018 0z" />
              </svg>
              <h3 className="text-lg font-semibold">Tư vấn trực tuyến</h3>
            </div>
            <button onClick={handleToggle} className="text-white transition-colors hover:text-gray-200">
              <svg xmlns="http://www.w3.org/2000/svg" className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          {/* Messages Area */}
          <div className="flex-1 p-4 space-y-3 overflow-y-auto bg-gray-800">
            {messages.map((message, index) => (
              <div key={index} className={`flex ${message.sender === 'user' ? 'justify-end' : 'justify-start'}`}>
                <div className={`flex items-end space-x-2 max-w-xs ${message.sender === 'user' ? 'flex-row-reverse space-x-reverse' : ''}`}>
                  {/* Avatar */}
                  <div className={`flex-shrink-0 h-8 w-8 rounded-full ${message.sender === 'user' ? 'bg-orange-500' : 'bg-gray-600'} flex items-center justify-center`}>
                    {message.sender === 'user' ? (
                      <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                      </svg>
                    ) : (
                      <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                      </svg>
                    )}
                  </div>
                  {/* Message Bubble */}
                  <div
                    className={`px-4 py-2 rounded-2xl ${
                      message.sender === 'user'
                        ? 'bg-orange-500 text-white rounded-br-none'
                        : 'bg-gray-700 text-gray-100 rounded-bl-none'
                    }`}
                  >
                    {message.text}
                  </div>
                </div>
              </div>
            ))}
            {isLoading && (
              <div className="flex justify-start">
                <div className="flex items-end space-x-2">
                  <div className="flex items-center justify-center flex-shrink-0 w-8 h-8 bg-gray-600 rounded-full">
                    <svg xmlns="http://www.w3.org/2000/svg" className="w-5 h-5 text-white animate-spin" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                    </svg>
                  </div>
                  <div className="px-4 py-2 text-gray-100 bg-gray-700 rounded-bl-none rounded-2xl">
                    Đang suy nghĩ...
                  </div>
                </div>
              </div>
            )}
            <div ref={messagesEndRef} />
          </div>

          {/* Input Area */}
          <div className="flex p-4 space-x-2 border-t border-gray-700">
            <input
              type="text"
              className="flex-1 px-3 py-2 text-white placeholder-gray-400 bg-gray-700 border border-gray-600 rounded-full focus:outline-none focus:ring-2 focus:ring-orange-500 disabled:opacity-50"
              placeholder="Nhập tin nhắn..."
              value={inputValue}
              onChange={handleInputChange}
              onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
              disabled={isLoading}
            />
            <button
              onClick={handleSendMessage}
              disabled={isLoading}
              className="p-2 text-white transition-colors bg-orange-500 rounded-full hover:bg-orange-600 focus:outline-none disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {/* Icon Send */}
              <svg xmlns="http://www.w3.org/2000/svg" className="w-6 h-6 transform rotate-90" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
              </svg>
            </button>
          </div>
        </div>
      ) : (
        // Toggle Button
        <button
          onClick={handleToggle}
          className="p-4 text-white transition-all duration-300 ease-in-out bg-orange-500 rounded-full shadow-lg hover:bg-orange-600 hover:shadow-xl focus:outline-none animate-pulse"
        >
          {/* Icon Chat */}
          <svg xmlns="http://www.w3.org/2000/svg" className="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
          </svg>
        </button>
      )}
    </div>
  );
};

export default Chatbot;