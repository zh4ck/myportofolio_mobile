import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

void main() {
  testWidgets('Profil dan aksi portofolio tampil dan merespons', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('2506550955'), findsOneWidget);
    expect(find.text('Zayyan Ramadzaki'), findsOneWidget);
    expect(find.text('PBP F'), findsOneWidget);

    final colors = <Color>{};
    for (final name in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
      final card = find.ancestor(
        of: find.text(name),
        matching: find.byType(ItemCard),
      );
      colors.add(tester.widget<ItemCard>(card).item.color);
      await tester.ensureVisible(find.text(name));
      await tester.tap(find.text(name));
      await tester.pump();
      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
      if (name == 'Tambah Proyek') {
        await tester.pumpAndSettle();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle();
      }
    }
    expect(colors.length, 3);
  });
}
