import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../features/service/model/service_model.dart';

class AdminEditServicePage extends StatefulWidget {
  final ServiceModel service;

  const AdminEditServicePage({super.key, required this.service});

  @override
  State<AdminEditServicePage> createState() => _AdminEditServicePageState();
}

class _AdminEditServicePageState extends State<AdminEditServicePage> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController priceController;
  late TextEditingController durationController;
  late TextEditingController imageController;
  late TextEditingController linkMapsController;

  late List<TextEditingController> workerControllers;
  late List<MapEntry<String, TextEditingController>> facilities;
  late List<String> initialPhotos;
  List<File> newPhotos = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.service.name);
    addressController = TextEditingController(text: widget.service.address);
    priceController = TextEditingController(text: widget.service.price.toString());
    durationController = TextEditingController(text: widget.service.serviceDurationMinutes.toString());
    imageController = TextEditingController(text: widget.service.image);
    linkMapsController = TextEditingController(text: widget.service.linkMaps);

    workerControllers = widget.service.workerNames.map((e) => TextEditingController(text: e)).toList();

    facilities = widget.service.facilities
        .map((f) => MapEntry(f.name, TextEditingController(text: f.detail?.toString() ?? '')))
        .toList();

    initialPhotos = List<String>.from(widget.service.photos ?? []);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    priceController.dispose();
    durationController.dispose();
    imageController.dispose();
    linkMapsController.dispose();
    for (var controller in workerControllers) {
      controller.dispose();
    }
    for (var entry in facilities) {
      entry.value.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        newPhotos.add(File(picked.path));
      });
    }
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Photos", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...initialPhotos.map(
                  (url) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(url, width: 100, height: 100, fit: BoxFit.cover),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          initialPhotos.remove(url);
                        });
                      },
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...newPhotos.map(
                  (file) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          newPhotos.remove(file);
                        });
                      },
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Icon(Icons.add_a_photo, size: 30),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _buildDynamicList<T>({
    required String title,
    required List<TextEditingController> controllers,
    required VoidCallback onAdd,
    required void Function(int) onRemove,
    required String Function(int) labelBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...controllers.asMap().entries.map((entry) {
          final index = entry.key;
          return Row(
            children: [
              Expanded(child: _buildTextField(labelBuilder(index), entry.value)),
              IconButton(
                onPressed: () => onRemove(index),
                icon: const Icon(Icons.delete),
              ),
            ],
          );
        }),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text("Tambah"),
          ),
        ),
      ],
    );
  }

  Widget _buildFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Fasilitas", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...facilities.asMap().entries.map((entry) {
          final index = entry.key;
          final nameController = TextEditingController(text: facilities[index].key);
          return Row(
            children: [
              Expanded(child: _buildTextField("Nama", nameController)),
              const SizedBox(width: 8),
              Expanded(child: _buildTextField("Detail", facilities[index].value)),
              IconButton(
                onPressed: () {
                  setState(() {
                    facilities.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          );
        }),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              facilities.add(MapEntry("", TextEditingController()));
            });
          },
          icon: const Icon(Icons.add),
          label: const Text("Tambah Fasilitas"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField('Nama', nameController),
            _buildTextField('Alamat', addressController),
            _buildTextField('Harga', priceController),
            _buildTextField('Durasi (menit)', durationController),
            _buildTextField('Link Gambar Utama', imageController),
            _buildTextField('Link Maps', linkMapsController),
            const SizedBox(height: 12),
            _buildDynamicList(
              title: 'Pekerja',
              controllers: workerControllers,
              onAdd: () {
                setState(() {
                  workerControllers.add(TextEditingController());
                });
              },
              onRemove: (index) {
                setState(() {
                  workerControllers.removeAt(index);
                });
              },
              labelBuilder: (i) => 'Pekerja ${i + 1}',
            ),
            const SizedBox(height: 16),
            _buildFacilities(),
            const SizedBox(height: 16),
            _buildPhotoSection(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Simpan perubahan
              },
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}
