import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:servista/core/custom_widgets/custom_button_widget.dart';

import '../../../../core/theme/color_value.dart';
import '../../../../features/service/bloc/service_bloc.dart';
import '../../../../features/service/bloc/service_event.dart';
import '../../../../features/service/bloc/service_state.dart';
import '../../../../features/service/model/service_model.dart';

class AdminEditServicePage extends StatefulWidget {
  final ServiceModel service;

  const AdminEditServicePage({super.key, required this.service});

  @override
  State<AdminEditServicePage> createState() => _AdminEditServicePageState();
}

class _AdminEditServicePageState extends State<AdminEditServicePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController linkMapsController = TextEditingController();

  List<TextEditingController> workerControllers = [];
  List<MapEntry<TextEditingController, TextEditingController>> facilities = [];

  File? mainImageFile;
  String? mainImageUrl; // URL gambar existing
  List<File> photoFiles = [];
  List<String> existingPhotoUrls = []; // URLs foto existing
  List<String> deletedPhotoUrls = []; // URLs foto yang dihapus

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize text controllers dengan data existing
    nameController.text = widget.service.name;
    addressController.text = widget.service.address;
    priceController.text = widget.service.price.toString();
    discountController.text = widget.service.discount.toString();
    linkMapsController.text = widget.service.linkMaps;

    // Initialize worker controllers
    workerControllers = widget.service.workerNames
        .map((worker) => TextEditingController(text: worker))
        .toList();
    if (workerControllers.isEmpty) {
      workerControllers.add(TextEditingController());
    }

    // Initialize facility controllers
    facilities = widget.service.facilities
        .map((facility) => MapEntry(
      TextEditingController(text: facility.name),
      TextEditingController(text: facility.detail),
    ))
        .toList();
    if (facilities.isEmpty) {
      facilities.add(MapEntry(TextEditingController(), TextEditingController()));
    }

    // Initialize image URLs
    mainImageUrl = widget.service.image;
    existingPhotoUrls = List.from(widget.service.photos);
  }

  Future<void> _pickMainImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        mainImageFile = File(picked.path);
        mainImageUrl = null; // Clear existing URL karena diganti dengan file baru
      });
    }
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        photoFiles.add(File(picked.path));
      });
    }
  }

  void _removeExistingPhoto(String photoUrl) {
    setState(() {
      existingPhotoUrls.remove(photoUrl);
      deletedPhotoUrls.add(photoUrl);
    });
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType inputType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: inputType,
            maxLength: 100,
            buildCounter: (_, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) =>
            null,
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorValue.darkColor,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffDFDFDF), width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffDFDFDF), width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gambar Utama",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (mainImageFile != null || mainImageUrl != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: mainImageFile != null
                    ? Image.file(
                  mainImageFile!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  mainImageUrl!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => setState(() {
                    mainImageFile = null;
                    mainImageUrl = null;
                  }),
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickMainImage,
          child: CustomButtonWidget(
            label: mainImageFile != null || mainImageUrl != null
                ? "Ganti Gambar Utama"
                : "Pilih Gambar Utama",
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Foto Tambahan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Existing photos from URLs
            ...existingPhotoUrls.map(
                  (photoUrl) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      photoUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => _removeExistingPhoto(photoUrl),
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
            // New photos from files
            ...photoFiles.map(
                  (file) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => setState(() => photoFiles.remove(file)),
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
            // Add photo button
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

  Widget _buildWorkerFields() {
    return _buildDynamicList(
      title: 'Pekerja',
      controllers: workerControllers,
      onAdd: () => setState(() => workerControllers.add(TextEditingController())),
      onRemove: (i) => setState(() => workerControllers.removeAt(i)),
      labelBuilder: (i) => 'Pekerja ${i + 1}',
    );
  }

  Widget _buildFacilitiesFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Fasilitas", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...facilities.asMap().entries.map((entry) {
          final index = entry.key;
          final nameCtrl = entry.value.key;
          final detailCtrl = entry.value.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(child: _buildTextField("Nama", nameCtrl)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField("Detail", detailCtrl)),
                IconButton(
                  onPressed: facilities.length > 1
                      ? () => setState(() => facilities.removeAt(index))
                      : null,
                  icon: Icon(
                    Icons.delete,
                    color: facilities.length > 1 ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
        GestureDetector(
          onTap: () => setState(
                () => facilities.add(
              MapEntry(TextEditingController(), TextEditingController()),
            ),
          ),
          child: CustomButtonWidget(label: "Tambah Fasilitas"),
        ),
      ],
    );
  }

  Widget _buildDynamicList({
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
        const SizedBox(height: 12),
        ...controllers.asMap().entries.map((entry) {
          final index = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildTextField(labelBuilder(index), entry.value),
                ),
                IconButton(
                  onPressed: controllers.length > 1 ? () => onRemove(index) : null,
                  icon: Icon(
                    Icons.delete,
                    color: controllers.length > 1 ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
        GestureDetector(
          onTap: onAdd,
          child: CustomButtonWidget(label: "Tambah $title"),
        ),
      ],
    );
  }

  void _submit() {
    if (nameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        discountController.text.trim().isEmpty ||
        linkMapsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Semua field wajib diisi!')));
      return;
    }

    final discountValue = int.tryParse(discountController.text.trim()) ?? 0;
    if (discountValue > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diskon tidak boleh lebih dari 100%')),
      );
      return;
    }

    if (priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harga tidak boleh kosong!')),
      );
      return;
    }

    if (mainImageFile == null && mainImageUrl == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pilih gambar utama dulu!')));
      return;
    }

    if (photoFiles.isEmpty && existingPhotoUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal 1 foto tambahan harus ada!')),
      );
      return;
    }

    final workers = workerControllers
        .map((e) => e.text.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (workers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal isi 1 nama pekerja!')),
      );
      return;
    }

    final fasilitas = facilities
        .where((f) => f.key.text.trim().isNotEmpty && f.value.text.trim().isNotEmpty)
        .map((f) => Facility(
      name: f.key.text.trim(),
      detail: f.value.text.trim(),
    ))
        .toList();
    if (fasilitas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal isi 1 fasilitas lengkap!')),
      );
      return;
    }

    final updatedService = ServiceModel(
      id: widget.service.id,
      name: nameController.text.trim(),
      address: addressController.text.trim(),
      image: mainImageUrl ?? '', // Will be updated if new image is uploaded
      range: widget.service.range,
      rating: widget.service.rating,
      discount: int.tryParse(discountController.text) ?? 0,
      price: int.tryParse(priceController.text) ?? 0,
      linkMaps: linkMapsController.text.trim(),
      facilities: fasilitas,
      photos: existingPhotoUrls, // Will be updated with new photos
      reviews: widget.service.reviews,
      seller_id: widget.service.seller_id,
      serviceDurationMinutes: widget.service.serviceDurationMinutes,
      operatingDays: widget.service.operatingDays,
      availableTimeSlots: widget.service.availableTimeSlots,
      workerNames: workers,
    );

    // Dispatch update event to bloc
    context.read<ServiceBloc>().add(
      UpdateSellerService(
        serviceModel: updatedService,
        mainImage: mainImageFile,
        additionalPhotos: photoFiles,
        deletedPhotoUrls: deletedPhotoUrls,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    priceController.dispose();
    discountController.dispose();
    linkMapsController.dispose();
    for (var controller in workerControllers) {
      controller.dispose();
    }
    for (var facility in facilities) {
      facility.key.dispose();
      facility.value.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Service"),
        elevation: 0,
        scrolledUnderElevation: 0.0,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocListener<ServiceBloc, ServiceState>(
          listener: (context, state) async {
            if (state is UpdateSellerServiceInProgress) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is UpdateSellerServiceSuccess) {
              // 1. Tutup dialog progress lebih aman
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }

              // 2. (opsional) snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Berhasil meng-update layanan!')),
              );

              // 3. Tutup halaman edit + kirim flag "true"
              if (context.mounted) Navigator.pop(context, true);
            }

            if (state is UpdateSellerServiceFailure) {
              Navigator.of(context).pop(); // Close loading dialog
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Gagal: ${state.error}')));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nama', nameController),
              _buildTextField('Alamat', addressController),
              _buildTextField(
                'Harga',
                priceController,
                inputType: TextInputType.number,
              ),
              _buildTextField(
                'Diskon (%)',
                discountController,
                inputType: TextInputType.number,
              ),
              _buildTextField('Link Maps', linkMapsController),
              const SizedBox(height: 20),
              _buildMainImageSection(),
              const SizedBox(height: 20),
              _buildWorkerFields(),
              const SizedBox(height: 20),
              _buildFacilitiesFields(),
              const SizedBox(height: 20),
              _buildPhotoSection(),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _submit,
                child: CustomButtonWidget(label: "Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}