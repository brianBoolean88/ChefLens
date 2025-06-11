# 👨‍🍳 ChefLens: AI-Powered Cooking Assistant  

ChefLens is a Flutter mobile application that uses AI to analyze photos of your ingredients and generate personalized recipe suggestions along with nutritional information. The app is built with Dart using Flutter in Visual Studio Code and connects to a continuation project called **Food Image AI Predictor**, powered by Google Colab and trained on the **Fruit Classification Dataset** (22k images) by Edward Zhang.


This app provides a unique value to users incomparable to other apps because the
service will be completely free to use, and no features will be locked behind paywalls.
Funding for the project will likely come from advertisements or sponsorships from
companies. Other nutrition tracking apps such as Cronometer have a subscription
service that gives the user simplified diet tracking. We will provide all of our services for
free, which makes the app much more accessible for younger people, as well as
families who may not be financially stable. Easy free-to-use access for teens promotes
early healthy eating and dieting, which can contribute to their well-being down the road.
Although there may be other apps that are also completely free, their apps are likely
made with very poor UI or programming, which may give off the impression to users that
the app is not trustworthy. They will not provide those apps with their private dietary
information. We will do better in this aspect by providing our users with an easy-to-use
UI and a streamlined navigational experience. Our app also utilizes AI, which will also
be free to use for the user. Many AI apps online may have their most sophisticated and
trained AI behind paywalls, which we will not have. The user will immediately have
access to our most accurate AI model to provide them with the most specific and helpful
results for their dieting and meal preparation needs.

---

## 📱 Introduction

**ChefLens** is designed to help users, especially amateur cooks and college students, prepare nutritious meals from the ingredients they have on hand. By leveraging computer vision and machine learning, the app identifies ingredients in user-submitted photos and recommends suitable recipes with detailed nutritional breakdowns.

---

## ❗ Problem Statement

Many people struggle with meal planning based on the ingredients they have, especially:
- College students with limited ingredients and experience.
- Busy individuals without time to search for recipes.
- Families trying to eat healthy on a budget.

Currently available apps are either paywalled, overly complex, or have poor UI/UX. ChefLens addresses this by offering:
- A **free and AI-driven** recipe generation tool.
- Intuitive and clean user interface.
- Nutritional and dietary customization options.

---

## 🎯 Target Audience

- **College students**
- **Amateur cooks**
- **Time-constrained individuals**
- **Budget-conscious families**
- **Health-focused users**

ChefLens is ideal for anyone looking to make smarter, healthier meal choices with minimal effort.

---

## 💡 Solution Overview

ChefLens works in two main stages:

1. **Image Ingredient Detection**
   - Users snap a photo of their available ingredients.
   - Images are sent to a machine learning backend (Google Colab model).
   - The model classifies and returns identified ingredients.

2. **AI-Generated Recipe & Nutrition Info**
   - The app suggests recipes sorted by user preferences:
     - Calories, protein, carbohydrates, fats
     - Vitamins, minerals, fiber, allergens
     - Cooking time & difficulty level
   - Each recipe includes step-by-step instructions and optional tutorial videos.

---

## 🔍 Unique Value Proposition

- **Completely free** to use — no features hidden behind paywalls.
- **Accurate ingredient detection** via trained AI model (22k image dataset).
- **High-quality UI/UX** built using Flutter, designed for simplicity and speed.
- **No locked AI tiers** — all users access the best prediction model.
- **Health-first advertising** — no fast food or junk food ads allowed.

---

## 💰 Revenue Model

ChefLens will remain free to use, monetized via:
- **Non-intrusive ads** (e.g., watch ad to unlock recipe).
- **Sponsored content** from health-oriented brands.
- **Optional donations** from satisfied users.

We are committed to keeping the user experience clean, ethical, and educational.

---

## 🧠 Tech Stack

| Component       | Technology                  |
|----------------|-----------------------------|
| **Frontend**    | Flutter (Dart)              |
| **IDE**         | Visual Studio Code          |
| **AI Backend**  | Google Colab (Python)       |
| **Dataset**     | Fruit Classification Dataset by Edward Zhang |
| **Image Model** | CNN model trained on 22k labeled images |

---

## 🤝 Team Strength

Our team brings a diverse blend of **technical, business, and communication skills**:

- 🧑‍💻 **Programming**: Extensive experience through side projects, USACO (Silver), and app competitions.
- 🧑‍🏫 **Business & Marketing**: 2+ years of FBLA participation with multiple awards.
- ✍️ **Writing & Presentation**: Strong ability to pitch, document, and communicate project value.
- 🤝 **Teamwork**: Clear communication, version control, and mutual support in all stages of development.

---

## 🏆 Awards & Recognition

- 🥇 1st and 2nd place – **Congressional App Challenge**
- 🥉 3rd place (2x) – **IgniteCS Programming Expo**
- 🏅 FBLA Award Winners – **Mobile App Design**, **Intro to IT**
- 🎖️ Advanced to **USACO Silver Division**

---

## 🔬 Supporting Project: Food Image AI Predictor

The **Food Image AI Predictor** is a continuation of ChefLens’s ingredient detection system:

- Built in **Google Colab** using **TensorFlow/Keras**
- Trained on the **Fruit Classification Dataset** (22,000 images)
- Fine-tuned CNN model outputs ingredient predictions from photos
- Outputs are returned to the Flutter app for recipe generation

---

## 🚧 Future Plans

- Expand dataset to include vegetables, grains, meats, and spices
- Add barcode scanning for packaged ingredients
- Integrate user meal logging and historical nutrition tracking
- Partner with grocery chains for real-time ingredient pricing

---

## 📎 Contact & Contributions

ChefLens is open to collaboration and partnership. For inquiries or contributions, please reach out via our competition submission channels or GitHub (to be linked).

---

## 🛠️ Installation & Setup

### 📦 Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- [Android Studio](https://developer.android.com/studio) or Xcode (macOS) --> for virtual device if needed
- [VS Code](https://code.visualstudio.com/) with Flutter & Dart extensions
- Git CLI
- Device/emulator for testing

### 📥 Installation Steps

```bash
git clone https://github.com/brianBoolean88/FBLA-Mobile-App-2023.git
cd FBLA-Mobile-App-2023
flutter pub get
```
1. Clone the repository to VSCode
2. Make sure you have all the relevant frameworks installed. There should be an android/iphone (virtual or real) device connected.
3. Run the Flutter application (flutter run or "Run" button in VSCode)
4. flutter build apk --release to export as APK for androids
   - As this application was created for androids, apple iphones may need a code rewrite in XCode for this project.
5. (Optional) run 'flutter doctor' if there are any issues

Happy looking at your recipes!!! :)

---

## 📜 License & Credits

- Fruit Dataset by Edward Zhang (used under fair use for educational purposes)
- Built using Flutter SDK and TensorFlow
- All components originally authored unless stated otherwise

---

*Built with ❤️ by aspiring developers for a healthier, smarter, and tastier future.*
