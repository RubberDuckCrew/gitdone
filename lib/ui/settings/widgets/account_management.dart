import "package:flutter/material.dart";
import "package:gitdone/core/models/current_user_model.dart";
import "package:gitdone/core/models/token_handler.dart";
import "package:github_flutter/github.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher.dart";

/// A widget that displays account management options for the user.
class AccountManagement extends StatelessWidget {
  /// Creates an instance of [AccountManagement].
  const AccountManagement({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
    create: (_) => AccountManagementViewModel(),
    child: Consumer<AccountManagementViewModel>(
      builder: (final context, final model, final child) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isValidUrl(model.avatarUrl))
                CircleAvatar(
                  backgroundImage: NetworkImage(model.avatarUrl!),
                  radius: 20,
                )
              else
                const Icon(Icons.account_circle, size: 40),
              const Padding(padding: EdgeInsets.all(2)),
              Text(
                model.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                ),
                onPressed: () {
                  if (_isValidUrl(model.htmlUrl)) {
                    launchUrl(Uri.parse(model.htmlUrl!));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile URL is not available."),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.account_circle_outlined, size: 18),
                label: const Text("Profile"),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                ),
                onPressed: () => TokenHandler.logout(context),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text("Logout"),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  bool _isValidUrl(final String? url) {
    if (url == null || url.isEmpty) return false;
    final Uri? uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }
}

/// A ViewModel for managing account-related data and actions.
class AccountManagementViewModel extends ChangeNotifier {
  /// Creates an instance of [AccountManagementViewModel] and initializes it.
  AccountManagementViewModel() {
    _init();
  }

  Future<void> _init() async {
    final User user = await CurrentUserModel.currentUser;
    username = user.login ?? "Unknown User";
    avatarUrl = user.avatarUrl;
    htmlUrl = user.htmlUrl;
    notifyListeners();
  }

  /// The username of the currently logged-in user.
  String username = "Loading...";

  /// The URL to the user's avatar image.
  String? avatarUrl;

  /// The URL to the user's GitHub profile.
  String? htmlUrl;
}
