import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(TailwindToFlutterApp());
}

class TailwindToFlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginScreen(),
    );
  }
}

// Controller untuk mengambil gambar
class ImagePickerController extends GetxController {
  var imageFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }
}

// Halaman Login
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _errorMessage = ''; // Menyimpan pesan kesalahan

  void _login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      _errorMessage = ''; // Reset pesan kesalahan
    });

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email and password cannot be empty';
      });
      return;
    }

    if (!isValidEmail(email) && !isValidPhoneNumber(email)) {
      setState(() {
        _errorMessage = 'Please enter a valid email or phone number';
      });
      return;
    }

    // Arahkan ke HomeScreen setelah login
    Get.to(HomeScreen());
  }

  bool isValidEmail(String email) {
    return email.endsWith('@gmail.com');
  }

  bool isValidPhoneNumber(String phone) {
    return RegExp(r'^\d{10,12}$').hasMatch(phone); // Memastikan panjang 10-12 digit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'El Movie',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red[600]),
              ),
              SizedBox(height: 50),
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade700,
                  hintText: 'Email or phone number',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                style: TextStyle(color: Colors.white),
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade700,
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 8), // Menambahkan jarak antara kolom password dan pesan kesalahan
              if (_errorMessage.isNotEmpty) 
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[600],
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Sign In', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Halaman Beranda
class HomeScreen extends StatelessWidget {
  final ImagePickerController imagePickerController = Get.put(ImagePickerController());

  // URL gambar untuk Top Movies dan Top Series
  final List<String> _topMovieImageUrls = [
    'https://image.tmdb.org/t/p/original/pANLUbUbOxruLAp8hZFlLszjK89.jpg',
    'https://m.media-amazon.com/images/I/71lqDylcvGL.jpg',
    'https://c4.wallpaperflare.com/wallpaper/175/302/384/dune-movie-movie-poster-hd-wallpaper-preview.jpg',
    'https://www.radicalismstudies.org/wp-content/uploads/2023/12/Film-13-Bom-di-Jakarta-Rilis-Poster-Terbaru.jpg',
    'https://www.themoviedb.org/t/p/original/7ZgIzK9tIfuSL4ql5ROsdeBl70D.jpg',
    'https://www.themoviedb.org/t/p/original/5WqIv1OR0ttUd6Tu3ePDPYqNdT0.jpg',
  ];

  final List<String> _topSeriesImageUrls = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRloL8X1uDaTpGKmIbn_5Vo4Ale1wQci2RymQ&s',
    'https://mir-s3-cdn-cf.behance.net/project_modules/1400/df219f128342993.61545007d2581.jpg',
    'https://www.canvasprintsaustralia.net.au/wp-content/uploads/2018/06/TWD.jpeg',
    'https://asriecitrawibowo.wordpress.com/wp-content/uploads/2020/06/wp-1592901331357.jpg',
    'https://www.themoviedb.org/t/p/original/rC9NjgNl9A0iXqNlCG1jqW3R2nV.jpg',
    'https://www.themoviedb.org/t/p/original/ftV3K2VvPI6eKZjbdZHHc8wsfXh.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildLogo()),
                SizedBox(height: 16),
                _buildProfilePicture(),
                SizedBox(height: 16),
                _buildTitle('For You'),
                SizedBox(height: 16),
                _buildCategoryButtons(),
                SizedBox(height: 16),
                _buildImageSection(),
                SizedBox(height: 16),
                _buildMovieDetails(),
                SizedBox(height: 16),
                _buildActionButtons(),
                SizedBox(height: 16),
                _buildTopMoviesSection(),
                SizedBox(height: 16),
                _buildTopSeriesSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
  

  Widget _buildLogo() {
    return Text(
      'El Movie',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red[600]),
    );
  }

  Widget _buildProfilePicture() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            imagePickerController.pickImage();
          },
          child: Obx(() {
            return CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              backgroundImage: imagePickerController.imageFile.value != null
                  ? FileImage(imagePickerController.imageFile.value!)
                  : null,
              child: imagePickerController.imageFile.value == null
                  ? Icon(Icons.camera_alt, color: Colors.white)
                  : null,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      children: [
        CategoryButton(text: 'Movies'),
        SizedBox(width: 8),
        CategoryButton(text: 'Series'),
        SizedBox(width: 8),
        CategoryButton(text: 'Categories', icon: Icons.arrow_drop_down),
      ],
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage('https://images.alphacoders.com/111/1119553.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMovieDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avengers: End Game',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(
          'Action • Superhero • Adventure • Science Fiction',
          style: TextStyle(color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ActionButton(
          icon: Icons.play_arrow,
          text: 'Play',
          backgroundColor: Colors.red[600]!,
          textColor: Colors.white,
        ),
        SizedBox(width: 8),
        ActionButton(
          icon: Icons.add,
          text: 'My List',
          backgroundColor: Colors.grey.shade800,
          textColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildTopMoviesSection() {
    return _buildSection('Top Movies', _topMovieImageUrls);
  }

  Widget _buildTopSeriesSection() {
    return _buildSection('Top Series', _topSeriesImageUrls);
  }

  Widget _buildSection(String title, List<String> imageUrls) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(imageUrls[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.whatshot, color: Colors.white), label: 'New&Hot'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle, color: Colors.white), label: 'Profile'),
      ],
      selectedItemColor: Colors.red[600],
       unselectedItemColor: Colors.white,
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String text;
  final IconData? icon;

  CategoryButton({required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          SizedBox(width: icon != null ? 8 : 0),
          Text(text, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color textColor;

  ActionButton({
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: textColor),
      label: Text(text, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
