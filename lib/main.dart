import 'package:flutter/material.dart';

void main() => runApp(const CocukPusula());

class CocukPusula extends StatelessWidget {
  const CocukPusula({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ÇocukPusula',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF6B66D8), scaffoldBackgroundColor: const Color(0xFFFFF9EC)),
    home: const HomeScreen(),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int stars = 0;
  String mood = 'Henüz seçilmedi';
  void award() => setState(() => stars++);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('🦊 ÇocukPusula'), actions: [Padding(padding: const EdgeInsets.all(12), child: Center(child: Text('⭐ $stars', style: const TextStyle(fontSize: 20))))]),
    body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      const Center(child: Text('🦊', style: TextStyle(fontSize: 110))),
      const Text('Merhaba! Ben Pus 👋', textAlign: TextAlign.center, style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Bugün birlikte cesur bir adım atalım!', textAlign: TextAlign.center),
      const SizedBox(height: 25),
      _tile('📖', 'Hikâye Dünyası', 'Pus’un İlk Okul Günü', () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoryScreen(onComplete: award)))),
      _tile('🎈', 'Oyun Alanı', 'Balon Nefesi', () => Navigator.push(context, MaterialPageRoute(builder: (_) => BreathingScreen(onComplete: award)))),
      _tile('🏆', 'Kazanımlarım', '$stars cesaret yıldızı', () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Kazanımlarım'), content: Text('Toplam $stars yıldız kazandın!'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))]))),
      const SizedBox(height: 18),
      const Text('Bugün nasıl hissediyorsun?', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      Wrap(spacing: 8, children: ['😊', '😌', '😟', '😢', '😠'].map((emoji) => ActionChip(label: Text(emoji, style: const TextStyle(fontSize: 27)), onPressed: () => setState(() => mood = emoji))).toList()),
      Text('Seçimin: $mood'),
      const SizedBox(height: 22),
      const Text('Ebeveyn notu: Bu uygulama psikoeğitim amaçlıdır; tanı veya tedavinin yerini almaz.', style: TextStyle(fontSize: 12, color: Colors.black54)),
    ])),
  );
  Widget _tile(String emoji, String title, String subtitle, VoidCallback tap) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(contentPadding: const EdgeInsets.all(15), leading: Text(emoji, style: const TextStyle(fontSize: 38)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(subtitle), trailing: const Icon(Icons.chevron_right), onTap: tap));
}

class StoryScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const StoryScreen({super.key, required this.onComplete});
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int scene = 0;
  bool finished = false;
  final texts = [
    'Bugün Pus’un yeni okulundaki ilk günüydü. Çantasını hazırladı ama karnında küçük kelebekler uçuşuyordu.',
    'Okul kapısında arkadaşlarını gördü. Kalbi hızlandı. “Ya kimse benimle oynamazsa?” diye düşündü.',
    'Pus bir an durdu. “Kaygılı olabilirim ve yine de küçük bir adım atabilirim,” dedi.',
    'Pus yanındaki tavşana gülümsedi: “Merhaba, ben Pus. Birlikte oynayabilir miyiz?”',
    'Tavşan gülümsedi. Pus cesur olmanın hiç korkmamak değil, korkarken de denemek olduğunu keşfetti.'
  ];
  void next() {
    if (scene < texts.length - 1) { setState(() => scene++); }
    else if (!finished) { widget.onComplete(); setState(() => finished = true); }
  }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Pus’un İlk Okul Günü')), body: SafeArea(child: Padding(padding: const EdgeInsets.all(22), child: Column(children: [
    LinearProgressIndicator(value: (scene + 1) / texts.length),
    const Spacer(),
    Text(['🦊🏡', '🦊🏫', '🦊💭', '🦊🐰', '🦊🌟'][scene], style: const TextStyle(fontSize: 85)),
    const SizedBox(height: 28),
    Text(texts[scene], textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, height: 1.5)),
    const Spacer(),
    if (scene == 1) ...[
      FilledButton.tonal(onPressed: next, child: const Text('Bir nefes alıp küçük bir adım at')),
      OutlinedButton(onPressed: next, child: const Text('Önce biraz etrafı gözlemle')),
    ] else FilledButton(onPressed: finished ? () => Navigator.pop(context) : next, child: Text(finished ? '⭐ Harika! Ana sayfaya dön' : scene == texts.length - 1 ? 'Hikâyeyi tamamla ⭐' : 'Devam et')),
    const SizedBox(height: 24),
  ]))));
}

class BreathingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const BreathingScreen({super.key, required this.onComplete});
  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  int step = 0;
  bool finished = false;
  final labels = ['Burnundan yavaşça nefes al', 'Rahatça nefes ver', 'Bir kez daha nefes al', 'Yavaşça nefes ver'];
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('🎈 Balon Nefesi')), body: SafeArea(child: Padding(padding: const EdgeInsets.all(25), child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    const Text('Pus ile birlikte nefesimizi fark edelim.', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
    AnimatedContainer(duration: const Duration(milliseconds: 700), width: step.isEven ? 190 : 130, height: step.isEven ? 190 : 130, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFFFFB5E8), Color(0xFF8A86F5)])), child: const Center(child: Text('🎈', style: TextStyle(fontSize: 70)))),
    Text(finished ? 'Harika! Bedenini dinledin.' : labels[step], style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    FilledButton(onPressed: () { if (finished) { Navigator.pop(context); return; } if (step == 3) { widget.onComplete(); setState(() => finished = true); } else { setState(() => step++); } }, child: Text(finished ? '⭐ Ana sayfaya dön' : 'Hazırım, devam et')),
    const Text('Nefesi zorlamadan, rahat hissettiğin hızda uygula.', textAlign: TextAlign.center),
  ]))));
}
