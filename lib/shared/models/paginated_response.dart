import 'package:equatable/equatable.dart';

/// Generic paginated response model
class PaginatedResponse<T> extends Equatable {
  final List<T> data;
  final PaginationLinks links;
  final PaginationMeta meta;

  const PaginatedResponse({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      data: (json['data'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      links: PaginationLinks.fromJson(json['links']),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }

  @override
  List<Object?> get props => [data, links, meta];
}

/// Pagination links
class PaginationLinks extends Equatable {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  const PaginationLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory PaginationLinks.fromJson(Map<String, dynamic> json) {
    return PaginationLinks(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }

  bool get hasNextPage => next != null;
  bool get hasPrevPage => prev != null;

  @override
  List<Object?> get props => [first, last, prev, next];
}

/// Pagination metadata
class PaginationMeta extends Equatable {
  final int currentPage;
  final int? from;
  final int lastPage;
  final String path;
  final int perPage;
  final int? to;
  final int total;

  const PaginationMeta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] as int,
      from: json['from'] as int?,
      lastPage: json['last_page'] as int,
      path: json['path'] as String,
      perPage: json['per_page'] as int,
      to: json['to'] as int?,
      total: json['total'] as int,
    );
  }

  bool get hasMorePages => currentPage < lastPage;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == lastPage;

  @override
  List<Object?> get props => [
        currentPage,
        from,
        lastPage,
        path,
        perPage,
        to,
        total,
      ];
}
