# 📱 کنترل حافظ (Hafez Controller)

[![Hafez Controller CI](https://github.com/HamidRezaAshkiyan/hafez_controller/actions/workflows/ci.yml/badge.svg)](https://github.com/HamidRezaAshkiyan/hafez_controller/actions/workflows/ci.yml)
[![Flutter 3](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-orange.svg)](https://github.com/HamidRezaAshkiyan/Hafez)

اپلیکیشن موبایل رسمی برای کنترل بی‌سیم نرم‌افزار نمایشگر مساجد **[حافظ (Hafez v2.0)](https://github.com/HamidRezaAshkiyan/Hafez)** از طریق شبکه محلی Wi-Fi (مبتنی بر **SignalR** و **REST API**).

📦 **دانلود فایل نصب اندروید (APK):** [GitHub Releases](https://github.com/HamidRezaAshkiyan/hafez_controller/releases/latest)  
🖥️ **نرم‌افزار دسکتاپ حافظ:** [HamidRezaAshkiyan/Hafez](https://github.com/HamidRezaAshkiyan/Hafez)  
🌐 **وب‌سایت پروژه:** https://hamidrezaashkiyan.github.io/Hafez/

---

## ✨ امکانات نسخه ۲.۰

- **اتصال فوری با اسکن کد QR:** کافیست در نرم‌افزار ویندوز حافظ کلید `Ctrl + Q` را بزنید و کد QR را با گوشی اسکن کنید.
- **همگام‌سازی لحظه‌ای با SignalR:** نمایش وضعیت اتصال (متصل / در حال اتصال / آفلاین) و وضعیت فعلی پخش زیرنویس، قرآن، مفاتیح، دوربین و گالری با اتصال مجدد خودکار.
- **اعلانات و اعلان اضطراری فوری:** انتخاب گروه اعلان از فهرست زنده سرور، ارسال زیرنویس جدید و ارسال اعلان اضطراری تک‌لمسی.
- **کنترل قرآن، مفاتیح و ادعیه اختصاصی:** انتخاب مستقیم سوره، شماره صفحه و ادعیه از فهرست دریافتی سرور به همراه کلیدهای پخش/توقف/بعدی/قبلی/شروع مجدد.
- **کنترل دوربین زنده و گالری:** روشن/خاموش کردن دوربین (با پنجره تأیید پیش از قطع پخش زنده) و انتخاب پوشه‌های گالری.
- **حالت شب (Dark Mode):** طراحی Material 3 با پشتیبانی کامل از راست‌به‌چپ (فارسی) و فونت وزیر.

---

## 📥 نصب و اتصال سریع

1. فایل `hafez-controller-v2.0.0.apk` را از بخش [Releases](https://github.com/HamidRezaAshkiyan/hafez_controller/releases/latest) روی گوشی اندرویدی خود نصب کنید.
2. مطمئن شوید گوشی و رایانه اجرای نرم‌افزار حافظ به یک شبکه Wi-Fi متصل هستند.
3. در نرم‌افزار ویندوز حافظ کلید `Ctrl + Q` را بزنید.
4. در اپلیکیشن موبایل روی آیکون **QR** در نوار بالا بزنید و کد را اسکن کنید.

---

## 🛠️ ساخت از کد منبع

```bash
git clone https://github.com/HamidRezaAshkiyan/hafez_controller.git
cd hafez_controller
flutter pub get
flutter test
flutter build apk --release
```
