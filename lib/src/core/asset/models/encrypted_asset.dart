/// Asset encryption result
class EncryptedAsset {
  final List<int> key;
  final List<int> data;
  final String hash;

  EncryptedAsset({
    required this.key,
    required this.data,
    required this.hash,
  });
}
