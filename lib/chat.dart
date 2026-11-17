import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bhumilestari_mobile/produk.dart';

/// Palet warna resmi modul Chat Pembeli BhumiLestari.
abstract final class BuyerChatPalette {
  static const Color canvas = Color(0xFFE9F3CF);
  static const Color darkSage = Color(0xFF4D665D);
  static const Color appBarSage = Color(0xFF617970);
  static const Color appBarIconDark = Color(0xFF253931);
  static const Color oliveAccent = Color(0xFFADC178);
  static const Color forestText = Color(0xFF1A2F35);
  static const Color creamText = Color(0xFFF2EAC0);
  static const Color bubbleSurface = Color(0xFFF8F9FE);
  static const Color bubbleBodyText = Color(0xFF55565B);
  static const Color chipUnselected = Color(0xFFEEEEEE);
  static const Color avatarBackground = Color(0xFFD9D9D9);
  static const Color avatarIcon = Color(0xFF8D8585);
  static const Color errorRed = Color(0xFFCB5242);
  static const Color starActive = Color(0xFFFFE540);
  static const Color starInactive = Color(0xFFF0EAD2);
}

/// Filter daftar percakapan/channel pembeli.
enum BuyerChatFilter {
  all('Semua'),
  unread('Belum dibaca'),
  archived('Diarsipkan');

  const BuyerChatFilter(this.label);
  final String label;
}

/// Mode halaman chat pembeli dari pop-up navigasi.
enum BuyerChatMode { regularChat, channel }

/// Struktur UI ringkas untuk satu item daftar chat penjual.
class BuyerChatSummary {
  const BuyerChatSummary({
    required this.id,
    required this.storeName,
    required this.lastMessage,
    this.unreadCount = 0,
    this.isArchived = false,
    this.statusText,
  });

  final String id;
  final String storeName;
  final String lastMessage;
  final int unreadCount;
  final bool isArchived;
  final String? statusText;
}

/// Struktur UI ringkas untuk satu item daftar channel toko.
class BuyerChannelSummary {
  const BuyerChannelSummary({
    required this.id,
    required this.channelName,
    required this.lastAnnouncement,
    this.unreadCount = 0,
    this.isArchived = false,
    this.followerLabel,
  });

  final String id;
  final String channelName;
  final String lastAnnouncement;
  final int unreadCount;
  final bool isArchived;
  final String? followerLabel;
}

/// Struktur UI ringkas untuk satu gelembung pesan chat / pengumuman channel.
class BuyerChatMessage {
  const BuyerChatMessage({
    required this.id,
    required this.text,
    required this.isFromBuyer,
    this.senderLabel,
    this.dateLabel,
    this.showContactSellerAction = false,
  });

  final String id;
  final String text;
  final bool isFromBuyer;
  final String? senderLabel;
  final String? dateLabel;
  final bool showContactSellerAction;
}

/// Menampilkan pop-up pilihan antara Chat Biasa atau Channel saat tab Chat ditekan.
Future<void> showBuyerChatModeDialog(
  BuildContext context, {
  BuyerChatMode? activeMode,
  bool replaceCurrentRoute = false,
}) {
  final navigator = Navigator.of(context);
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => BuyerChatModeDialog(
      activeMode: activeMode,
      onSelectRegularChat: () {
        Navigator.of(dialogContext).pop();
        if (activeMode == BuyerChatMode.regularChat) return;
        final route = MaterialPageRoute<void>(
          builder: (_) => const BuyerChatListPage(),
        );
        if (replaceCurrentRoute) {
          navigator.pushReplacement(route);
        } else {
          navigator.push(route);
        }
      },
      onSelectChannel: () {
        Navigator.of(dialogContext).pop();
        if (activeMode == BuyerChatMode.channel) return;
        final route = MaterialPageRoute<void>(
          builder: (_) => const BuyerChannelListPage(),
        );
        if (replaceCurrentRoute) {
          navigator.pushReplacement(route);
        } else {
          navigator.push(route);
        }
      },
    ),
  );
}

/// Dialog pilihan mode Chat Pembeli: Chat Biasa atau Channel.
class BuyerChatModeDialog extends StatelessWidget {
  const BuyerChatModeDialog({
    super.key,
    required this.onSelectRegularChat,
    required this.onSelectChannel,
    this.activeMode,
  });

  final VoidCallback onSelectRegularChat;
  final VoidCallback onSelectChannel;
  final BuyerChatMode? activeMode;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: BuyerChatPalette.canvas,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pilih Menu Chat',
                      style: GoogleFonts.changa(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: BuyerChatPalette.forestText,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tutup',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: BuyerChatPalette.darkSage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Buka percakapan dengan penjual atau lihat pengumuman dari channel toko.',
                style: GoogleFonts.prompt(
                  fontSize: 13,
                  color: BuyerChatPalette.darkSage,
                ),
              ),
              const SizedBox(height: 16),
              _ModeChoiceCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Chat Biasa',
                subtitle: 'Percakapan langsung dengan penjual',
                isActive: activeMode == BuyerChatMode.regularChat,
                onTap: onSelectRegularChat,
              ),
              const SizedBox(height: 12),
              _ModeChoiceCard(
                icon: Icons.campaign_outlined,
                title: 'Channel',
                subtitle: 'Informasi dan pengumuman dari toko favorit',
                isActive: activeMode == BuyerChatMode.channel,
                onTap: onSelectChannel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeChoiceCard extends StatelessWidget {
  const _ModeChoiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? BuyerChatPalette.oliveAccent : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: BuyerChatPalette.darkSage.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isActive
                    ? BuyerChatPalette.darkSage
                    : BuyerChatPalette.canvas,
                child: Icon(
                  icon,
                  color: isActive ? Colors.white : BuyerChatPalette.darkSage,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.changa(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: BuyerChatPalette.forestText,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.prompt(
                        fontSize: 12,
                        color: isActive
                            ? BuyerChatPalette.forestText
                            : BuyerChatPalette.darkSage,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: BuyerChatPalette.forestText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Halaman awal daftar Chat Pembeli (tanpa data dummy bawaan).
class BuyerChatListPage extends StatefulWidget {
  const BuyerChatListPage({
    super.key,
    this.buyerName,
    this.chats = const [],
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.onOpenChat,
  });

  final String? buyerName;
  final List<BuyerChatSummary> chats;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ValueChanged<BuyerChatSummary>? onOpenChat;

  @override
  State<BuyerChatListPage> createState() => _BuyerChatListPageState();
}

class _BuyerChatListPageState extends State<BuyerChatListPage> {
  final TextEditingController _searchController = TextEditingController();
  BuyerChatFilter _selectedFilter = BuyerChatFilter.all;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BuyerChatSummary> get _filteredChats {
    final query = _searchQuery.trim().toLowerCase();
    return widget.chats.where((chat) {
      final matchesFilter = switch (_selectedFilter) {
        BuyerChatFilter.all => true,
        BuyerChatFilter.unread => chat.unreadCount > 0,
        BuyerChatFilter.archived => chat.isArchived,
      };
      if (!matchesFilter) return false;
      if (query.isEmpty) return true;
      return chat.storeName.toLowerCase().contains(query) ||
          chat.lastMessage.toLowerCase().contains(query);
    }).toList();
  }

  void _openRoomPreview() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const BuyerChatRoomPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredChats;
    final cleanName = widget.buyerName?.trim();
    final greeting = (cleanName != null && cleanName.isNotEmpty)
        ? 'Selamat datang, $cleanName!'
        : 'Selamat datang!';

    return _BuyerConversationHubScaffold(
      title: greeting,
      searchHint: 'Cari pesan Anda di sini',
      searchController: _searchController,
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      selectedFilter: _selectedFilter,
      onFilterChanged: (filter) => setState(() => _selectedFilter = filter),
      isLoading: widget.isLoading,
      errorMessage: widget.errorMessage,
      onRetry: widget.onRetry,
      isEmpty: filtered.isEmpty,
      emptyIcon: Icons.chat_bubble_outline_rounded,
      emptyTitle: widget.chats.isEmpty
          ? 'Belum ada percakapan'
          : 'Percakapan tidak ditemukan',
      emptyDescription: widget.chats.isEmpty
          ? 'Daftar percakapan dengan penjual akan tampil di sini setelah data terhubung.'
          : 'Tidak ada pesan yang cocok dengan pencarian atau filter yang dipilih.',
      previewButtonLabel: 'Lihat Tampilan Room Chat',
      onPreviewRoom: _openRoomPreview,
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final chat = filtered[index];
        return _BuyerConversationListTile(
          title: chat.storeName,
          subtitle: chat.lastMessage,
          unreadCount: chat.unreadCount,
          isArchived: chat.isArchived,
          showTopBorder: index == 0,
          onTap: () {
            if (widget.onOpenChat != null) {
              widget.onOpenChat!(chat);
              return;
            }
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BuyerChatRoomPage(
                  storeName: chat.storeName,
                  statusText: chat.statusText,
                ),
              ),
            );
          },
        );
      },
      activeMode: BuyerChatMode.regularChat,
      buyerNavLabel: cleanName,
    );
  }
}

/// Halaman awal daftar Channel Pembeli (tanpa data dummy bawaan).
class BuyerChannelListPage extends StatefulWidget {
  const BuyerChannelListPage({
    super.key,
    this.buyerName,
    this.channels = const [],
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.onOpenChannel,
  });

  final String? buyerName;
  final List<BuyerChannelSummary> channels;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ValueChanged<BuyerChannelSummary>? onOpenChannel;

  @override
  State<BuyerChannelListPage> createState() => _BuyerChannelListPageState();
}

class _BuyerChannelListPageState extends State<BuyerChannelListPage> {
  final TextEditingController _searchController = TextEditingController();
  BuyerChatFilter _selectedFilter = BuyerChatFilter.all;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BuyerChannelSummary> get _filteredChannels {
    final query = _searchQuery.trim().toLowerCase();
    return widget.channels.where((channel) {
      final matchesFilter = switch (_selectedFilter) {
        BuyerChatFilter.all => true,
        BuyerChatFilter.unread => channel.unreadCount > 0,
        BuyerChatFilter.archived => channel.isArchived,
      };
      if (!matchesFilter) return false;
      if (query.isEmpty) return true;
      return channel.channelName.toLowerCase().contains(query) ||
          channel.lastAnnouncement.toLowerCase().contains(query);
    }).toList();
  }

  void _openChannelPreview() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const BuyerChannelRoomPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredChannels;
    final cleanName = widget.buyerName?.trim();

    return _BuyerConversationHubScaffold(
      title: 'Channel Favoritmu',
      searchHint: 'Cari channel Anda di sini',
      searchController: _searchController,
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      selectedFilter: _selectedFilter,
      onFilterChanged: (filter) => setState(() => _selectedFilter = filter),
      isLoading: widget.isLoading,
      errorMessage: widget.errorMessage,
      onRetry: widget.onRetry,
      isEmpty: filtered.isEmpty,
      emptyIcon: Icons.campaign_outlined,
      emptyTitle: widget.channels.isEmpty
          ? 'Belum ada channel favorit'
          : 'Channel tidak ditemukan',
      emptyDescription: widget.channels.isEmpty
          ? 'Daftar channel toko yang Anda ikuti akan tampil di sini setelah data terhubung.'
          : 'Tidak ada channel yang cocok dengan pencarian atau filter yang dipilih.',
      previewButtonLabel: 'Lihat Tampilan Room Channel',
      onPreviewRoom: _openChannelPreview,
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final channel = filtered[index];
        return _BuyerConversationListTile(
          title: channel.channelName,
          subtitle: channel.lastAnnouncement,
          unreadCount: channel.unreadCount,
          isArchived: channel.isArchived,
          showTopBorder: index == 0,
          onTap: () {
            if (widget.onOpenChannel != null) {
              widget.onOpenChannel!(channel);
              return;
            }
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BuyerChannelRoomPage(
                  channelName: channel.channelName,
                  followerLabel: channel.followerLabel,
                ),
              ),
            );
          },
        );
      },
      activeMode: BuyerChatMode.channel,
      buyerNavLabel: cleanName,
    );
  }
}

class _BuyerConversationHubScaffold extends StatelessWidget {
  const _BuyerConversationHubScaffold({
    required this.title,
    required this.searchHint,
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    required this.isEmpty,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyDescription,
    required this.previewButtonLabel,
    required this.onPreviewRoom,
    required this.itemCount,
    required this.itemBuilder,
    required this.activeMode,
    this.buyerNavLabel,
  });

  final String title;
  final String searchHint;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final BuyerChatFilter selectedFilter;
  final ValueChanged<BuyerChatFilter> onFilterChanged;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool isEmpty;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyDescription;
  final String previewButtonLabel;
  final VoidCallback onPreviewRoom;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final BuyerChatMode activeMode;
  final String? buyerNavLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BuyerChatPalette.canvas,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                  child: Text(
                    title,
                    style: GoogleFonts.changa(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: BuyerChatPalette.forestText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: GoogleFonts.prompt(
                      fontSize: 14,
                      color: BuyerChatPalette.forestText,
                    ),
                    decoration: InputDecoration(
                      hintText: searchHint,
                      hintStyle: GoogleFonts.prompt(
                        fontSize: 14,
                        color: BuyerChatPalette.avatarIcon,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              tooltip: 'Hapus pencarian',
                              onPressed: () {
                                searchController.clear();
                                onSearchChanged('');
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                                color: BuyerChatPalette.avatarIcon,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: BuyerChatFilter.values.map((filter) {
                      final isSelected = selectedFilter == filter;
                      return _BuyerFilterChip(
                        label: filter.label,
                        isSelected: isSelected,
                        onTap: () => onFilterChanged(filter),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: _buildBodyState(context),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BuyerBottomNavigationBar(
        activeMode: activeMode,
        buyerLabel: buyerNavLabel,
      ),
    );
  }

  Widget _buildBodyState(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: BuyerChatPalette.darkSage),
            const SizedBox(height: 12),
            Text(
              'Memuat daftar...',
              style: GoogleFonts.prompt(
                fontSize: 13,
                color: BuyerChatPalette.darkSage,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null && errorMessage!.trim().isNotEmpty) {
      return _BuyerStateMessage(
        icon: Icons.error_outline_rounded,
        title: 'Gagal memuat data',
        description: errorMessage!,
        actionLabel: onRetry != null ? 'Coba Lagi' : null,
        onAction: onRetry,
      );
    }

    if (isEmpty) {
      return _BuyerStateMessage(
        icon: emptyIcon,
        title: emptyTitle,
        description: emptyDescription,
        actionLabel: previewButtonLabel,
        onAction: onPreviewRoom,
      );
    }

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}

class _BuyerFilterChip extends StatelessWidget {
  const _BuyerFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? BuyerChatPalette.oliveAccent
          : BuyerChatPalette.chipUnselected,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 36),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            child: Text(
              label,
              style: GoogleFonts.prompt(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: BuyerChatPalette.forestText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BuyerConversationListTile extends StatelessWidget {
  const _BuyerConversationListTile({
    required this.title,
    required this.subtitle,
    required this.unreadCount,
    required this.isArchived,
    required this.showTopBorder,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final int unreadCount;
  final bool isArchived;
  final bool showTopBorder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = unreadCount > 0;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: showTopBorder
                ? const BorderSide(color: BuyerChatPalette.darkSage, width: 1)
                : BorderSide.none,
            bottom: const BorderSide(
              color: BuyerChatPalette.darkSage,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            const _BuyerAvatarCircle(radius: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.prompt(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: BuyerChatPalette.darkSage,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.prompt(
                      fontSize: 12.5,
                      fontWeight: isUnread ? FontWeight.w700 : FontWeight.w400,
                      color: BuyerChatPalette.darkSage,
                    ),
                  ),
                ],
              ),
            ),
            if (isUnread) ...[
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 12,
                backgroundColor: BuyerChatPalette.oliveAccent,
                child: Text(
                  '$unreadCount',
                  style: GoogleFonts.prompt(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: BuyerChatPalette.forestText,
                  ),
                ),
              ),
            ] else if (isArchived) ...[
              const SizedBox(width: 10),
              const Icon(
                Icons.inventory_2_outlined,
                size: 20,
                color: BuyerChatPalette.darkSage,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BuyerStateMessage extends StatelessWidget {
  const _BuyerStateMessage({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.secondaryLabel,
    this.onSecondaryAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: BuyerChatPalette.darkSage.withValues(alpha: 0.12),
              child: Icon(
                icon,
                size: 28,
                color: BuyerChatPalette.darkSage,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.changa(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: BuyerChatPalette.forestText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                fontSize: 13,
                color: BuyerChatPalette.darkSage,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton(
                    onPressed: onAction,
                    style: FilledButton.styleFrom(
                      backgroundColor: BuyerChatPalette.oliveAccent,
                      foregroundColor: BuyerChatPalette.forestText,
                      minimumSize: const Size(44, 44),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      actionLabel!,
                      style: GoogleFonts.prompt(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (secondaryLabel != null && onSecondaryAction != null)
                    OutlinedButton(
                      onPressed: onSecondaryAction,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: BuyerChatPalette.darkSage,
                        side: const BorderSide(
                          color: BuyerChatPalette.darkSage,
                        ),
                        minimumSize: const Size(44, 44),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        secondaryLabel!,
                        style: GoogleFonts.prompt(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Halaman ruang chat pembeli dengan penjual (tanpa data dummy bawaan).
class BuyerChatRoomPage extends StatefulWidget {
  const BuyerChatRoomPage({
    super.key,
    this.storeName,
    this.statusText,
    this.messages = const [],
    this.onSendMessage,
    this.onContactSellerTap,
  });

  final String? storeName;
  final String? statusText;
  final List<BuyerChatMessage> messages;
  final ValueChanged<String>? onSendMessage;
  final VoidCallback? onContactSellerTap;

  @override
  State<BuyerChatRoomPage> createState() => _BuyerChatRoomPageState();
}

class _BuyerChatRoomPageState extends State<BuyerChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      showBuyerChatToast(
        context,
        message: 'Pesan tidak boleh kosong.',
        isError: true,
      );
      return;
    }

    if (widget.onSendMessage != null) {
      widget.onSendMessage!(text);
      _messageController.clear();
      return;
    }

    showBuyerChatToast(
      context,
      message: 'Pengiriman pesan belum terhubung ke server.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = (widget.storeName?.trim().isNotEmpty ?? false)
        ? widget.storeName!.trim()
        : 'Nama Toko';
    final subtitle = (widget.statusText?.trim().isNotEmpty ?? false)
        ? widget.statusText!.trim()
        : 'Status toko belum tersedia';

    return Scaffold(
      backgroundColor: BuyerChatPalette.canvas,
      appBar: _BuyerRoomAppBar(
        title: title,
        subtitle: subtitle,
        actions: [
          IconButton(
            tooltip: 'Hubungi via telepon',
            onPressed: () => showBuyerChatToast(
              context,
              message: 'Panggilan belum tersedia.',
            ),
            icon: const Icon(
              Icons.call,
              color: BuyerChatPalette.appBarIconDark,
            ),
          ),
          IconButton(
            tooltip: 'Blokir atau laporkan pengguna',
            onPressed: () => showBuyerReportDialog(context),
            icon: const Icon(
              Icons.person_off,
              color: BuyerChatPalette.appBarIconDark,
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Opsi obrolan',
            icon: const Icon(
              Icons.more_vert,
              color: BuyerChatPalette.appBarIconDark,
            ),
            onSelected: (value) {
              if (value == 'rating') {
                showBuyerRatingDialog(context);
              } else if (value == 'report') {
                showBuyerReportDialog(context);
              } else if (value == 'toast_ok') {
                showBuyerChatToast(
                  context,
                  message: 'Data berhasil disimpan!',
                );
              } else if (value == 'toast_err') {
                showBuyerChatToast(
                  context,
                  message: 'Data gagal disimpan!',
                  isError: true,
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'rating',
                child: Text('Beri Rating Percakapan'),
              ),
              PopupMenuItem(
                value: 'report',
                child: Text('Laporkan Pengguna'),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'toast_ok',
                child: Text('Pratinjau Toast Berhasil'),
              ),
              PopupMenuItem(
                value: 'toast_err',
                child: Text('Pratinjau Toast Gagal'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: widget.messages.isEmpty
                    ? _BuyerStateMessage(
                        icon: Icons.forum_outlined,
                        title: 'Belum ada pesan',
                        description:
                            'Riwayat pesan dengan penjual akan tampil di sini setelah data percakapan tersedia.',
                        actionLabel: 'Pratinjau Rating',
                        onAction: () => showBuyerRatingDialog(context),
                        secondaryLabel: 'Pratinjau Laporan',
                        onSecondaryAction: () => showBuyerReportDialog(context),
                      )
                    : _BuyerMessageListView(
                        messages: widget.messages,
                        onContactSellerTap: widget.onContactSellerTap,
                      ),
              ),
            ),
          ),
          _BuyerChatComposerBar(
            controller: _messageController,
            onAttachmentTap: () => showBuyerChatToast(
              context,
              message: 'Fitur lampiran belum tersedia.',
            ),
            onSendTap: _handleSend,
          ),
        ],
      ),
    );
  }
}

/// Halaman ruang channel pembeli (read-only, tanpa data dummy bawaan).
class BuyerChannelRoomPage extends StatelessWidget {
  const BuyerChannelRoomPage({
    super.key,
    this.channelName,
    this.followerLabel,
    this.announcements = const [],
  });

  final String? channelName;
  final String? followerLabel;
  final List<BuyerChatMessage> announcements;

  @override
  Widget build(BuildContext context) {
    final title = (channelName?.trim().isNotEmpty ?? false)
        ? channelName!.trim()
        : 'Nama Channel';
    final subtitle = (followerLabel?.trim().isNotEmpty ?? false)
        ? followerLabel!.trim()
        : 'Channel Toko';

    return Scaffold(
      backgroundColor: BuyerChatPalette.canvas,
      appBar: _BuyerRoomAppBar(
        title: title,
        subtitle: subtitle,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Opsi channel',
            icon: const Icon(
              Icons.more_vert,
              color: BuyerChatPalette.appBarIconDark,
            ),
            onSelected: (value) {
              if (value == 'report') {
                showBuyerReportDialog(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'report',
                child: Text('Laporkan Channel'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: announcements.isEmpty
                    ? const _BuyerStateMessage(
                        icon: Icons.campaign_outlined,
                        title: 'Belum ada pengumuman',
                        description:
                            'Pesan atau pengumuman dari pemilik channel akan tampil di sini.',
                      )
                    : _BuyerMessageListView(messages: announcements),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: BuyerChatPalette.appBarSage,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: SafeArea(
              top: false,
              child: Text(
                'Anda tidak punya akses untuk mengirim pesan pada channel ini',
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyerRoomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _BuyerRoomAppBar({
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: BuyerChatPalette.appBarSage,
      foregroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        tooltip: 'Kembali',
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: BuyerChatPalette.creamText,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          const _BuyerAvatarCircle(radius: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.changa(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.prompt(
                    fontSize: 12,
                    color: BuyerChatPalette.creamText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }
}

class _BuyerMessageListView extends StatelessWidget {
  const _BuyerMessageListView({
    required this.messages,
    this.onContactSellerTap,
  });

  final List<BuyerChatMessage> messages;
  final VoidCallback? onContactSellerTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      itemCount: messages.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final msg = messages[index];
        final showDate = msg.dateLabel != null &&
            (index == 0 || messages[index - 1].dateLabel != msg.dateLabel);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDate) ...[
              Center(child: _BuyerDatePill(label: msg.dateLabel!)),
              const SizedBox(height: 14),
            ],
            _BuyerMessageBubble(
              message: msg,
              onContactSellerTap: onContactSellerTap,
            ),
          ],
        );
      },
    );
  }
}

class _BuyerDatePill extends StatelessWidget {
  const _BuyerDatePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: BuyerChatPalette.avatarBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: GoogleFonts.prompt(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: BuyerChatPalette.forestText,
        ),
      ),
    );
  }
}

class _BuyerMessageBubble extends StatelessWidget {
  const _BuyerMessageBubble({
    required this.message,
    this.onContactSellerTap,
  });

  final BuyerChatMessage message;
  final VoidCallback? onContactSellerTap;

  @override
  Widget build(BuildContext context) {
    final maxBubbleWidth = MediaQuery.sizeOf(context).width * 0.72;
    final alignRight = message.isFromBuyer;

    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxBubbleWidth.clamp(220, 440)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: alignRight
                ? BuyerChatPalette.darkSage
                : BuyerChatPalette.bubbleSurface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!alignRight &&
                  message.senderLabel != null &&
                  message.senderLabel!.trim().isNotEmpty) ...[
                Text(
                  message.senderLabel!,
                  style: GoogleFonts.prompt(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: BuyerChatPalette.bubbleBodyText,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              Text(
                message.text,
                style: GoogleFonts.prompt(
                  fontSize: 13,
                  height: 1.45,
                  color: alignRight ? Colors.white : BuyerChatPalette.forestText,
                ),
              ),
              if (!alignRight && message.showContactSellerAction) ...[
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: onContactSellerTap ??
                      () => showBuyerChatToast(
                            context,
                            message: 'Menghubungkan ke penjual belum tersedia.',
                          ),
                  style: FilledButton.styleFrom(
                    backgroundColor: BuyerChatPalette.oliveAccent,
                    foregroundColor: BuyerChatPalette.forestText,
                    minimumSize: const Size(44, 36),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    'Hubungi Penjual',
                    style: GoogleFonts.prompt(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BuyerChatComposerBar extends StatelessWidget {
  const _BuyerChatComposerBar({
    required this.controller,
    required this.onAttachmentTap,
    required this.onSendTap,
  });

  final TextEditingController controller;
  final VoidCallback onAttachmentTap;
  final VoidCallback onSendTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BuyerChatPalette.appBarSage,
      padding: const EdgeInsets.fromLTRB(8, 10, 14, 10),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Tambah lampiran',
                  onPressed: onAttachmentTap,
                  icon: const Icon(
                    Icons.add,
                    color: BuyerChatPalette.oliveAccent,
                    size: 28,
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: BuyerChatPalette.bubbleSurface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.only(left: 16, right: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => onSendTap(),
                            style: GoogleFonts.prompt(
                              fontSize: 13.5,
                              color: BuyerChatPalette.forestText,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ketik pesan Anda...',
                              hintStyle: GoogleFonts.prompt(
                                fontSize: 13.5,
                                color: BuyerChatPalette.avatarIcon,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Kirim pesan',
                          onPressed: onSendTap,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          padding: EdgeInsets.zero,
                          icon: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: BuyerChatPalette.oliveAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Menampilkan popover rating setelah mengobrol dengan penjual.
Future<void> showBuyerRatingDialog(
  BuildContext context, {
  void Function(int rating, String feedback)? onSubmit,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => BuyerRatingDialog(
      onSubmit: (rating, feedback) {
        Navigator.of(dialogContext).pop();
        if (onSubmit != null) {
          onSubmit(rating, feedback);
        } else if (context.mounted) {
          showBuyerChatToast(context, message: 'Data berhasil disimpan!');
        }
      },
    ),
  );
}

/// Popover pemberian rating & feedback percakapan pembeli.
class BuyerRatingDialog extends StatefulWidget {
  const BuyerRatingDialog({
    super.key,
    required this.onSubmit,
  });

  final void Function(int rating, String feedback) onSubmit;

  @override
  State<BuyerRatingDialog> createState() => _BuyerRatingDialogState();
}

class _BuyerRatingDialogState extends State<BuyerRatingDialog> {
  final TextEditingController _feedbackController = TextEditingController();
  int _selectedStars = 0;
  String? _validationMessage;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_selectedStars == 0) {
      setState(() {
        _validationMessage = 'Pilih rating bintang terlebih dahulu.';
      });
      return;
    }
    widget.onSubmit(_selectedStars, _feedbackController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return _BuyerFeedbackDialogShell(
      title: 'Ratingmu terhadap percakapan tadi',
      fieldLabel: 'Feedback :',
      fieldHint: 'Masukkan feedback Anda...',
      submitLabel: 'Beri Rating',
      controller: _feedbackController,
      validationMessage: _validationMessage,
      onSubmit: _handleSubmit,
      topContent: Wrap(
        alignment: WrapAlignment.center,
        spacing: 4,
        runSpacing: 4,
        children: List.generate(5, (index) {
          final starValue = index + 1;
          final isFilled = starValue <= _selectedStars;
          return IconButton(
            tooltip: 'Bintang $starValue',
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            padding: EdgeInsets.zero,
            onPressed: () => setState(() {
              _selectedStars = starValue;
              _validationMessage = null;
            }),
            icon: Icon(
              Icons.star_rounded,
              size: 34,
              color: isFilled
                  ? BuyerChatPalette.starActive
                  : BuyerChatPalette.starInactive,
            ),
          );
        }),
      ),
    );
  }
}

/// Menampilkan popover laporan pengguna.
Future<void> showBuyerReportDialog(
  BuildContext context, {
  ValueChanged<String>? onSubmit,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => BuyerReportDialog(
      onSubmit: (reason) {
        Navigator.of(dialogContext).pop();
        if (onSubmit != null) {
          onSubmit(reason);
        } else if (context.mounted) {
          showBuyerChatToast(context, message: 'Data berhasil disimpan!');
        }
      },
    ),
  );
}

/// Popover pelaporan penjual/pengguna oleh pembeli.
class BuyerReportDialog extends StatefulWidget {
  const BuyerReportDialog({
    super.key,
    required this.onSubmit,
  });

  final ValueChanged<String> onSubmit;

  @override
  State<BuyerReportDialog> createState() => _BuyerReportDialogState();
}

class _BuyerReportDialogState extends State<BuyerReportDialog> {
  final TextEditingController _reasonController = TextEditingController();
  String? _validationMessage;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(() {
        _validationMessage = 'Alasan pelaporan wajib diisi.';
      });
      return;
    }
    widget.onSubmit(reason);
  }

  @override
  Widget build(BuildContext context) {
    return _BuyerFeedbackDialogShell(
      title: 'Laporkan Pengguna ini?',
      centerTitle: true,
      fieldLabel: 'Alasan Pelaporan:',
      fieldHint: 'Masukkan alasan pelaporan Anda...',
      submitLabel: 'Laporkan',
      controller: _reasonController,
      validationMessage: _validationMessage,
      onChanged: (_) {
        if (_validationMessage != null) {
          setState(() => _validationMessage = null);
        }
      },
      onSubmit: _handleSubmit,
    );
  }
}

class _BuyerFeedbackDialogShell extends StatelessWidget {
  const _BuyerFeedbackDialogShell({
    required this.title,
    required this.fieldLabel,
    required this.fieldHint,
    required this.submitLabel,
    required this.controller,
    required this.onSubmit,
    this.centerTitle = false,
    this.topContent,
    this.validationMessage,
    this.onChanged,
  });

  final String title;
  final bool centerTitle;
  final String fieldLabel;
  final String fieldHint;
  final String submitLabel;
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final Widget? topContent;
  final String? validationMessage;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: BuyerChatPalette.canvas,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                style: GoogleFonts.changa(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: BuyerChatPalette.darkSage,
                ),
              ),
              if (topContent != null) ...[
                const SizedBox(height: 12),
                topContent!,
              ],
              const SizedBox(height: 16),
              Text(
                fieldLabel,
                style: GoogleFonts.changa(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: BuyerChatPalette.darkSage,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                onChanged: onChanged,
                minLines: 4,
                maxLines: 5,
                style: GoogleFonts.prompt(
                  fontSize: 13.5,
                  color: BuyerChatPalette.forestText,
                ),
                decoration: InputDecoration(
                  hintText: fieldHint,
                  hintStyle: GoogleFonts.prompt(
                    fontSize: 13.5,
                    color: BuyerChatPalette.avatarIcon,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
              if (validationMessage != null) ...[
                const SizedBox(height: 12),
                BuyerChatToastCard(
                  message: validationMessage!,
                  isError: true,
                ),
              ],
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  onPressed: onSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: BuyerChatPalette.oliveAccent,
                    foregroundColor: BuyerChatPalette.forestText,
                    minimumSize: const Size(120, 42),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    submitLabel,
                    style: GoogleFonts.prompt(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Menampilkan pemberitahuan toast gaya BhumiLestari (sukses atau gagal).
void showBuyerChatToast(
  BuildContext context, {
  required String message,
  bool isError = false,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 3),
        content: Center(
          child: BuyerChatToastCard(
            message: message,
            isError: isError,
          ),
        ),
      ),
    );
}

/// Kartu toast putih dengan garis tepi kiri hijau (sukses) atau merah (gagal).
class BuyerChatToastCard extends StatelessWidget {
  const BuyerChatToastCard({
    super.key,
    required this.message,
    this.isError = false,
  });

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final stripeColor =
        isError ? BuyerChatPalette.errorRed : BuyerChatPalette.darkSage;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 240, maxWidth: 340),
      child: Material(
        color: Colors.white,
        elevation: 4,
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 9, color: stripeColor),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  child: Text(
                    message,
                    style: GoogleFonts.prompt(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: BuyerChatPalette.forestText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuyerAvatarCircle extends StatelessWidget {
  const _BuyerAvatarCircle({required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: BuyerChatPalette.avatarBackground,
      child: Icon(
        Icons.person,
        color: BuyerChatPalette.avatarIcon,
        size: radius * 1.25,
      ),
    );
  }
}

class _BuyerBottomNavigationBar extends StatelessWidget {
  const _BuyerBottomNavigationBar({
    required this.activeMode,
    this.buyerLabel,
  });

  final BuyerChatMode activeMode;
  final String? buyerLabel;

  @override
  Widget build(BuildContext context) {
    final profileLabel = (buyerLabel != null && buyerLabel!.isNotEmpty)
        ? buyerLabel!
        : 'Pengguna';

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: BuyerChatPalette.darkSage,
      selectedItemColor: BuyerChatPalette.creamText,
      unselectedItemColor: BuyerChatPalette.creamText,
      iconSize: 28,
      selectedLabelStyle: GoogleFonts.prompt(
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.prompt(fontSize: 10),
      currentIndex: 3,
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ProdukPage()),
          );
        } else if (index == 3) {
          showBuyerChatModeDialog(
            context,
            activeMode: activeMode,
            replaceCurrentRoute: true,
          );
        } else {
          // TODO: Hubungkan halaman Keranjang, Riwayat Beli, dan Profil Pengguna.
          showBuyerChatToast(
            context,
            message: 'Halaman masih dalam pengembangan.',
          );
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Produk',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Keranjang',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Riwayat Beli',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat_outlined),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: const CircleAvatar(
            radius: 14,
            backgroundColor: BuyerChatPalette.avatarBackground,
            child: Icon(
              Icons.person,
              color: BuyerChatPalette.avatarIcon,
              size: 18,
            ),
          ),
          label: profileLabel,
        ),
      ],
    );
  }
}
