import 'contact.dart';

class ContactPage {
  const ContactPage({
    required this.items,
    required this.hasNextPage,
    required this.nextCursor,
  });

  final List<Contact> items;
  final bool hasNextPage;
  final String? nextCursor;
}
