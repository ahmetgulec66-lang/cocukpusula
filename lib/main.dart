import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() { WidgetsFlutterBinding.ensureInitialized(); runApp(const CocukPusula()); }
const ink = Color(0xFF17365B);
const aqua = Color(0xFF12B8B2);
const cream = Color(0xFFFFF8EA);

class CocukPusula extends StatelessWidget {
  const CocukPusula({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ÇocukPusula',
    theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto', scaffoldBackgroundColor: cream, colorScheme: ColorScheme.fromSeed(seedColor: aqua), appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: ink)),
    home: const StartScreen(),
  );
}

class StartScreen extends StatefulWidget { const StartScreen({super.key}); @override State<StartScreen> createState() => _StartScreenState(); }
class _StartScreenState extends State<StartScreen> {
  bool loading = true, configured = false;
  int age = 7, stars = 0;
  String character = 'girl', mood = '';
  @override void initState() { super.initState(); load(); }
  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() { configured = p.getBool('configured') ?? false; age = p.getInt('age') ?? 7; character = p.getString('character') ?? 'girl'; stars = p.getInt('stars') ?? 0; mood = p.getString('mood') ?? ''; loading = false; });
  }
  Future<void> saveProfile(int a, String c) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('age', a); await p.setString('character', c); await p.setBool('configured', true);
    if (!mounted) return; setState(() { age = a; character = c; configured = true; });
  }
  Future<void> addStar() async {
    final p = await SharedPreferences.getInstance(); await p.setInt('stars', stars + 1);
    if (mounted) setState(() => stars++);
  }
  Future<void> setMood(String value) async {
    final p = await SharedPreferences.getInstance(); await p.setString('mood', value);
    if (mounted) setState(() => mood = value);
  }
  @override Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return configured ? HomeScreen(age: age, character: character, stars: stars, mood: mood, onMood: setMood, onStar: addStar, onProfile: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(age: age, character: character, onSave: saveProfile)))) : ProfileScreen(age: age, character: character, onSave: saveProfile, firstRun: true);
  }
}

class ProfileScreen extends StatefulWidget {
  final int age; final String character; final Future<void> Function(int, String) onSave; final bool firstRun;
  const ProfileScreen({super.key, required this.age, required this.character, required this.onSave, this.firstRun = false});
  @override State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  late int age; late String character; bool saving = false;
  @override void initState() { super.initState(); age = widget.age; character = widget.character; }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.firstRun ? 'Macera arkadaşını seç' : 'Profil ayarları'), automaticallyImplyLeading: !widget.firstRun),
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(22), children: [
      const Text('Hoş geldin, küçük kâşif! ✨', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ink)),
      const SizedBox(height: 8), const Text('Önce yaşını, sonra sana eşlik edecek Pus karakterini seç.', style: TextStyle(fontSize: 16, color: ink)),
      const SizedBox(height: 25), const Text('Kaç yaşındasın?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ink)), const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: [for (int n=4; n<=12; n++) ChoiceChip(label: Text('$n', style: const TextStyle(fontSize: 18)), selected: age == n, onSelected: (_) => setState(() => age = n))]),
      const SizedBox(height: 28), const Text('Hangi Pus ile maceraya çıkalım?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ink)), const SizedBox(height: 12),
      Row(children: [Expanded(child: characterCard('girl', 'Kız Pus', '🦊', const Color(0xFFFFE0F0))), const SizedBox(width: 12), Expanded(child: characterCard('boy', 'Erkek Pus', '🦊', const Color(0xFFD9F3FF)))]),
      const SizedBox(height: 18), const Text('İki Pus da aynı maceralara katılabilir. Karakterini sonradan değiştirebilirsin.', style: TextStyle(color: ink)),
      const SizedBox(height: 26), FilledButton(onPressed: saving ? null : () async { setState(() => saving = true); await widget.onSave(age, character); if (!context.mounted) return; if (!widget.firstRun) Navigator.pop(context); }, style: FilledButton.styleFrom(backgroundColor: aqua, padding: const EdgeInsets.symmetric(vertical: 18)), child: Text(saving ? 'Kaydediliyor...' : 'Maceraya Başla →', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    ])),
  );
  Widget characterCard(String value, String title, String emoji, Color color) => InkWell(onTap: () => setState(() => character = value), borderRadius: BorderRadius.circular(24), child: AnimatedContainer(duration: const Duration(milliseconds: 230), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24), border: Border.all(color: character == value ? aqua : Colors.transparent, width: 4)), child: Column(children: [Text(emoji, style: const TextStyle(fontSize: 72)), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ink)), Icon(character == value ? Icons.check_circle : Icons.circle_outlined, color: aqua)])));
}

class HomeScreen extends StatelessWidget {
  final int age, stars; final String character, mood; final Future<void> Function(String) onMood; final Future<void> Function() onStar; final VoidCallback onProfile;
  const HomeScreen({super.key, required this.age, required this.character, required this.stars, required this.mood, required this.onMood, required this.onStar, required this.onProfile});
  @override Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [
      Row(children: [const Icon(Icons.explore, color: aqua, size: 32), const SizedBox(width: 8), const Expanded(child: Text('ÇocukPusula', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink))), Chip(label: Text('⭐ $stars'))]),
      const SizedBox(height: 14),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFBDEFE8), Color(0xFFFFE8BC)]), borderRadius: BorderRadius.circular(30)), child: Column(children: [
        Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Merhaba, kâşif! 👋', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 8), Text('$age yaş • ${character == 'girl' ? 'Kız Pus' : 'Erkek Pus'}', style: const TextStyle(color: ink)), const SizedBox(height: 10), const Text('Her duygu yeni bir keşif!', style: TextStyle(fontSize: 17, color: ink))])), const Text('🦊', style: TextStyle(fontSize: 92))]),
        const SizedBox(height: 8), const Text('Bugün birlikte küçük bir cesaret adımı atalım.', style: TextStyle(color: ink)),
      ])),
      const SizedBox(height: 22), const Text('Keşif dünyan', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: ink)), const SizedBox(height: 12),
      Row(children: [Expanded(child: feature(context, '📖', 'Hikâyeler', 'Pus’un okul macerası', const Color(0xFFFFE0C2), () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryScreen(character: character, onComplete: onStar))))), const SizedBox(width: 12), Expanded(child: feature(context, '🎈', 'Oyunlar', 'Balon nefesi', const Color(0xFFDAD8FF), () => Navigator.push(context, MaterialPageRoute(builder: (_) => BreathingScreen(onComplete: onStar)))))]),
      const SizedBox(height: 12), Row(children: [Expanded(child: feature(context, '🏆', 'Yıldızlarım', '$stars cesaret yıldızı', const Color(0xFFFFF0B9), () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Kazanımlarım'), content: Text('$stars cesaret yıldızı kazandın!'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))])))), const SizedBox(width: 12), Expanded(child: feature(context, '⚙️', 'Profil', 'Yaş ve karakter seçimi', const Color(0xFFCFF2E7), onProfile))]),
      const SizedBox(height: 25), const Text('Bugün nasıl hissediyorsun?', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: ink)), const SizedBox(height: 8),
      Wrap(spacing: 9, runSpacing: 8, children: [for (final e in ['😊','😌','😟','😢','😠']) ChoiceChip(label: Text(e, style: const TextStyle(fontSize: 26)), selected: mood == e, onSelected: (_) => onMood(e))]),
      const SizedBox(height: 22), const Text('Ebeveyn notu: Bu uygulama psikoeğitim amaçlıdır; tanı veya tedavi yerine geçmez.', style: TextStyle(fontSize: 12, color: Colors.black54)),
    ])),
  );
  Widget feature(BuildContext context, String emoji, String title, String detail, Color bg, VoidCallback tap) => InkWell(onTap: tap, borderRadius: BorderRadius.circular(24), child: Container(height: 164, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(emoji, style: const TextStyle(fontSize: 44)), const Spacer(), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: ink)), Text(detail, maxLines: 2, style: const TextStyle(fontSize: 12, color: ink))])));
}

class StoryScreen extends StatefulWidget {
  final String character; final Future<void> Function() onComplete;
  const StoryScreen({super.key, required this.character, required this.onComplete});
  @override State<StoryScreen> createState() => _StoryScreenState();
}
class _StoryScreenState extends State<StoryScreen> {
  int step = 0; bool awarded = false;
  final scenes = const [
    ('🏫', 'Pus’un İlk Okul Günü', 'Pus, okulun kapısında durdu. Karnında küçük kelebekler uçuşuyordu. Yeni bir yere girmek biraz zor gelebilirdi.'),
    ('💭', 'Duygularımı Tanıyorum', 'Pus kendi kendine sordu: “Şu an ne hissediyorum?” Hem heyecanlı hem de biraz kaygılıydı.'),
    ('🌬️', 'Küçük Bir Mola', 'Pus yavaşça nefes aldı. Kaygısının hemen kaybolması gerekmiyordu. Kaygısıyla birlikte küçük bir adım atabilirdi.'),
    ('🤝', 'Cesaret Adımı', 'Pus öğretmenine yaklaşıp “Biraz heyecanlıyım, bana sınıfı gösterebilir misin?” dedi.'),
    ('⭐', 'Başardın!', 'Pus sınıfa girdi. Cesaret, hiç korkmamak değil; korkarken de küçük adımlar deneyebilmekti.'),
  ];
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Pus’un İlk Okul Günü')), body: SafeArea(child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
    LinearProgressIndicator(value: (step+1)/scenes.length, minHeight: 9, borderRadius: BorderRadius.circular(9), color: aqua), const SizedBox(height: 24),
    Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFD8F4ED), Color(0xFFFFE8C4)]), borderRadius: BorderRadius.circular(30)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(scenes[step].$1, style: const TextStyle(fontSize: 86)), const Text('🦊', style: TextStyle(fontSize: 72)), const SizedBox(height: 20), Text(scenes[step].$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: ink)), const SizedBox(height: 18), Text(scenes[step].$3, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, height: 1.45, color: ink))]))),
    const SizedBox(height: 18), if (step == 1) const Text('Pus ne hissediyor? Kaygı da normal bir duygudur.', textAlign: TextAlign.center),
    SizedBox(width: double.infinity, child: FilledButton(onPressed: () async { if (step < scenes.length-1) { setState(() => step++); } else { if (!awarded) { awarded = true; await widget.onComplete(); } if (context.mounted) Navigator.pop(context); } }, style: FilledButton.styleFrom(backgroundColor: aqua, padding: const EdgeInsets.all(17)), child: Text(step == scenes.length-1 ? 'Yıldızımı Al ⭐' : 'Devam Et →', style: const TextStyle(fontSize: 18))))
  ]))));
}

class BreathingScreen extends StatefulWidget { final Future<void> Function() onComplete; const BreathingScreen({super.key, required this.onComplete}); @override State<BreathingScreen> createState() => _BreathingScreenState(); }
class _BreathingScreenState extends State<BreathingScreen> {
  bool expanded = false, awarded = false; int rounds = 0;
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Balon Nefesi')), body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Text('Pus ile yavaş nefes alıp verelim 🎈', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ink)), const SizedBox(height: 35),
    Center(child: AnimatedContainer(duration: const Duration(seconds: 2), curve: Curves.easeInOut, width: expanded ? 230 : 135, height: expanded ? 230 : 135, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFFE2F6), Color(0xFFDD7BBE)])), child: const Center(child: Text('🎈', style: TextStyle(fontSize: 72))))),
    const SizedBox(height: 40), Text(expanded ? 'Şimdi yavaşça nefes ver...' : 'Hazırsan yavaşça nefes al...', textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, color: ink)), const SizedBox(height: 24),
    FilledButton(onPressed: () => setState(() { if (expanded) rounds++; expanded = !expanded; }), child: Text(expanded ? 'Nefes Ver' : 'Nefes Al')), const SizedBox(height: 12), Text('Tamamlanan tur: $rounds / 3'),
    if (rounds >= 3) Padding(padding: const EdgeInsets.only(top: 18), child: FilledButton(onPressed: awarded ? null : () async { awarded = true; await widget.onComplete(); if (context.mounted) Navigator.pop(context); }, child: const Text('Cesaret Yıldızımı Al ⭐'))),
    const SizedBox(height: 24), const Text('Rahatsızlık veya baş dönmesi olursa egzersizi durdur.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 12))
  ]))));
}

