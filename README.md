# 🍳 RecipeMaster - Flutter Tarif Uygulaması


Firebase tabanlı modern tarif uygulaması. Kullanıcılar tarif paylaşabilir, keşfedebilir ve favorilerine ekleyebilir. GetX state management ile yüksek performanslı Flutter uygulaması.

## ✨ Temel Özellikler
- 🔐 Firebase Authentication ile güvenli giriş/kayıt
- 📱 OTP doğrulama desteği
- 🖼️ Tarif fotoğrafı yükleme
- 📝 Dinamik malzeme ve adım ekleme (CRUD)
- ❤️ Favori tarif yönetimi
- 🍽️ Yiyecek/içecek kategorilerine göre filtreleme
- 👤 Kişiselleştirilmiş profil sayfası

## 🖼️ Uygulama Ekranları

<div align="center">
  <table>
    <tr>
      <td><img src="screens/onboarding.jpeg" width="200" alt="Hoş Geldiniz"></td>
      <td><img src="screens/login.jpeg" width="200" alt="Giriş Yap"></td>
      <td><img src="screens/register.jpeg" width="200" alt="Kayıt Ol"></td>
    </tr>
    <tr>
      <td><i>Hoş Geldiniz Ekranı</i></td>
      <td><i>OTP Girişi</i></td>
      <td><i>Kayıt Ekranı</i></td>
    </tr>
    <tr>
      <td><img src="screens/homepage.jpeg" width="200" alt="Ana Sayfa"></td>
      <td><img src="screens/meal_card.jpeg" width="200" alt="Tarif Kartı"></td>
      <td><img src="screens/meal_detail.jpeg" width="200" alt="Tarif Detay"></td>
    </tr>
    <tr>
      <td><i>Kategorilere Göre Tarifler</i></td>
      <td><i>Tarif Özet Kartı</i></td>
      <td><i>Detaylı Tarif Görünümü</i></td>
    </tr>
    <tr>
      <td><img src="screens/add_meal.jpeg" width="200" alt="Tarif Ekle"></td>
      <td><img src="screens/description.jpeg" width="200" alt="Adım Ekleme"></td>
      <td><img src="screens/profile.jpeg" width="200" alt="Profil"></td>
    </tr>
    <tr>
      <td><i>Yeni Tarif Oluştur</i></td>
      <td><i>Dinamik Adım Ekleme</i></td>
      <td><i>Kullanıcı Profili</i></td>
    </tr>
  </table>
</div>

## 🛠️ Teknoloji Yığını

| Bileşen          | Teknoloji                     |
|------------------|-------------------------------|
| Framework        | Flutter 3.x                   |
| State Management | GetX                          |
| Backend          | Firebase (Auth, Firestore)    |
| Kimlik Doğrulama | Firebase Auth + OTP           |
| API              | RESTful                       |
| Storage          | Firebase Storage              |
| UI/UX            | Custom Animations             |

## 🚀 Kurulum

1. Repository'i klonlayın:
```bash
git clone https://github.com/sizin-kullanici-adi/recipe-app.git
