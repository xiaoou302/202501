import '../models/art_model.dart';
import '../models/artist_model.dart';
import '../datasources/mock_data.dart';

class ArtRepository {
  List<ArtModel> _artworks = [];
  List<ArtistModel> _artists = [];

  ArtRepository() {
    _artworks = MockData.getArtworks();
    _artists = MockData.getArtists();
  }

  Future<List<ArtModel>> getGalleryArts({List<String>? categories}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (categories == null || categories.isEmpty || categories.contains('All')) {
      return _artworks;
    }
    
    return _artworks.where((art) {
      return art.categories.any((cat) => categories.contains(cat));
    }).toList();
  }

  Future<ArtModel> getArtDetail(String artId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _artworks.firstWhere((art) => art.id == artId);
  }

  Future<void> addToCollection(String artId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _artworks.indexWhere((art) => art.id == artId);
    if (index != -1) {
      _artworks[index] = _artworks[index].copyWith(isInCollection: true);
    }
  }

  Future<ArtistModel> getArtistById(String artistId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _artists.firstWhere((artist) => artist.id == artistId);
  }

  Future<List<ArtModel>> getArtworksByArtist(String artistId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _artworks.where((art) => art.artistId == artistId).toList();
  }
}
