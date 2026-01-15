import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/repositories/art_repository.dart';
import '../../data/models/artist_model.dart';
import '../../data/models/art_model.dart';

class ArtistProfileScreen extends StatefulWidget {
  final String artistId;

  const ArtistProfileScreen({super.key, required this.artistId});

  @override
  State<ArtistProfileScreen> createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen> {
  final ArtRepository _repository = ArtRepository();
  ArtistModel? _artist;
  List<ArtModel> _artworks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final artist = await _repository.getArtistById(widget.artistId);
      final artworks = await _repository.getArtworksByArtist(widget.artistId);
      setState(() {
        _artist = artist;
        _artworks = artworks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppConstants.midnight,
        body: Center(
          child: CircularProgressIndicator(color: AppConstants.gold),
        ),
      );
    }

    if (_artist == null) {
      return const Scaffold(
        backgroundColor: AppConstants.midnight,
        body: Center(
          child: Text('Artist not found', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.midnight,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildPortfolio(),
              ],
            ),
          ),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      decoration: const BoxDecoration(
        color: AppConstants.surface,
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppConstants.gold, width: 2),
                  image: _artist!.avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(_artist!.avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      _artist!.name,
                      style: const TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 24,
                        color: AppConstants.offwhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _artist!.biography,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.metalgray,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _artist!.styles.map((style) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white10),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            style,
                            style: TextStyle(
                              fontSize: 10,
                              color: style == _artist!.styles.first
                                  ? AppConstants.gold
                                  : AppConstants.metalgray,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.midnight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: const Border(
                left: BorderSide(color: AppConstants.gold, width: 2),
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: 0,
                  left: 0,
                  child: Icon(
                    Icons.format_quote,
                    color: Colors.white10,
                    size: 32,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    _artist!.philosophy,
                    style: const TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: AppConstants.offwhite,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolio() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              'PORTFOLIO',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppConstants.metalgray,
                letterSpacing: 1.5,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: _artworks.length,
            itemBuilder: (context, index) {
              final artwork = _artworks[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Image.network(
                    artwork.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
