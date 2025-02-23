/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:io';

import 'package:pdf_fork/pdf.dart';
import 'package:pdf_fork/widgets.dart';
import 'package:test/test.dart';

late Document pdf;

void main() {
  setUpAll(() {
    Document.debug = true;
    RichText.debug = true;
    pdf = Document();
  });

  test('Flex Widgets ListView', () {
    pdf.addPage(
      Page(
        build: (Context context) => ListView(
          spacing: 20,
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            Text('Line 1'),
            Text('Line 2'),
            Text('Line 3'),
          ],
        ),
      ),
    );
  });

  test('Flex Widgets ListView.builder', () {
    pdf.addPage(
      Page(
        build: (Context context) => ListView.builder(
          itemBuilder: (Context context, int index) => Text('Line $index'),
          itemCount: 30,
          spacing: 2,
          reverse: true,
        ),
      ),
    );
  });

  test('Flex Widgets ListView.separated', () {
    pdf.addPage(
      Page(
        build: (Context context) => ListView.separated(
          separatorBuilder: (Context context, int index) => Container(
            color: PdfColors.grey,
            height: 0.5,
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
          itemBuilder: (Context context, int index) => Text('Line $index'),
          itemCount: 10,
        ),
      ),
    );
  });

  test('Flex Widgets Spacer', () {
    pdf.addPage(
      Page(
        build: (Context context) => Column(
          children: <Widget>[
            Text('Begin'),
            Spacer(), // Defaults to a flex of one.
            Text('Middle'),
            // Gives twice the space between Middle and End than Begin and Middle.
            Spacer(flex: 2),
            // Expanded(flex: 2, child: SizedBox.shrink()),
            Text('End'),
          ],
        ),
      ),
    );
  });

  test('MultiPage Spacer', () {
    pdf.addPage(
      MultiPage(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        build: (Context context) => <Widget>[
          for (int i = 0; i < 60; i++) Text('Begin $i'),
          Spacer(), // Defaults to a flex of one.
          Text('Middle'),
          // Gives twice the space between Middle and End than Begin and Middle.
          Spacer(flex: 2),
          // Expanded(flex: 2, child: SizedBox.shrink()),
          Text('End'),
        ],
      ),
    );
  });

  tearDownAll(() async {
    final file = File('widgets-flex.pdf');
    await file.writeAsBytes(await pdf.save());
  });
}
