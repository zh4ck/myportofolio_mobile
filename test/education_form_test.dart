import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Kartu membuka formulir, validasi dan dialog bekerja', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Tambah Edukasi'));
    await tester.tap(find.text('Tambah Edukasi'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Kolom ini wajib diisi'), findsNWidgets(2));
    expect(find.text('Tahun wajib diisi'), findsOneWidget);
    expect(find.text('Ringkasan Edukasi'), findsNothing);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Institusi'),
      '   ',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Jurusan'),
      'Informatika',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Tahun mulai'),
      'abcd',
    );
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Kolom ini wajib diisi'), findsOneWidget);
    expect(
      find.text('Masukkan tahun antara 1900 dan tahun sekarang'),
      findsOneWidget,
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Institusi'),
      'Universitas Indonesia',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Tahun mulai'),
      '2025',
    );
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Institusi: Universitas Indonesia'), findsOneWidget);
    expect(find.text('Jurusan: Informatika'), findsOneWidget);
    expect(find.text('Tahun mulai: 2025'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan Edukasi'), findsNothing);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio'), findsOneWidget);
  });

  testWidgets('Drawer membuka edukasi dan kembali ke Home', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Education'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Edukasi'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio'), findsOneWidget);
  });
}
