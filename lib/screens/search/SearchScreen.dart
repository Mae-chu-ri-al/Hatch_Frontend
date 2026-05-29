import 'package:flutter/material.dart';
import '../write_post/write_page/ApplyTeamDialog.dart';
import '../write_post/write_page/WritePostScreen.dart';
import '../card/VerticalStudyCard.dart';

class SearchScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allData;
  const SearchScreen({Key? key, required this.allData}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Color mintColor = const Color(0xFFBCE0D8);
  final Color activeBlueColor = const Color(0xFF80E2FF);

  bool _isFilterMenuOpen = false;

  // 여러 개의 필터를 담을 수 있도록 List로 변경
  List<String> _selectedFilters = [];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    //선택된 필터가 없거나, 항목의 카테고리가 선택된 리스트 안에 포함되어 있으면 표시
    final filteredData = widget.allData.where((item) {
      final matchesSearch = item['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['desc'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilters.isEmpty || _selectedFilters.contains(item['category']);
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCF6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))]),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28), onPressed: () => Navigator.pop(context)),
                  Expanded(
                    child: Container(
                      height: 48, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.grey.shade300, width: 1)),
                      child: Row(
                        children: [
                          const SizedBox(width: 15), Icon(Icons.search, color: Colors.grey.shade600, size: 24), const SizedBox(width: 10),
                          Expanded(
                              child: TextField(
                                  autofocus: true,
                                  onChanged: (value) => setState(() => _searchQuery = value),
                                  decoration: InputDecoration(hintText: "스터디를 검색하세요.", hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16), border: InputBorder.none)
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isFilterMenuOpen = !_isFilterMenuOpen),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]),
                        child: const Row(children: [Icon(Icons.filter_list, size: 20, color: Colors.black87), SizedBox(width: 5), Text("필터", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14))]),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // 여러 개의 선택된 필터를 가로로 나열
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _selectedFilters.map((filter) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedFilters.remove(filter)), // X 누르면 제거
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: activeBlueColor, borderRadius: BorderRadius.circular(8)),
                                child: Row(children: [Text(filter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)), const SizedBox(width: 6), const Icon(Icons.close, size: 16, color: Colors.white)]),
                              ),
                            ),
                          )).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredData.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final item = filteredData[index];
                    return VerticalStudyCard(
                      id: item['id']?.toString(),
                      title: item['title']!,
                      category: item['category']!,
                      desc: item['desc']!,
                      status: item['status']!,
                      members: item['members']!,
                      duration: item['duration']!,
                    );
                  },
                ),
              ),
            ],
          ),

          // 필터 팝업 메뉴
          if (_isFilterMenuOpen)
            Positioned(
              top: 70, left: 20,
              child: Container(
                width: 280, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 5))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("카테고리", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        // 팝업창 닫기 버튼
                        GestureDetector(
                            onTap: () => setState(() => _isFilterMenuOpen = false),
                            child: Icon(Icons.close, size: 20, color: Colors.grey.shade500)
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 10, runSpacing: 10,
                      children: [_buildDropdownChip("팀플"), _buildDropdownChip("스터디"), _buildDropdownChip("공모전")],
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10, right: 5),
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WritePostScreen(
                existingTitles: widget.allData.map((item) => item['title'].toString()).toList(),
              ),
            ),
          ),
          backgroundColor: mintColor, shape: const CircleBorder(), elevation: 5,
          child: const Icon(Icons.add, size: 35, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDropdownChip(String label) {
    // 리스트 안에 라벨이 들어있는지 확인
    bool isSelected = _selectedFilters.contains(label);
    return GestureDetector(
      onTap: () => setState(() {
        //이미 선택되어 있으면 빼고, 없으면 추가 (여러개 선택 가능하도록 메뉴는 닫지 않음)
        if (isSelected) {
          _selectedFilters.remove(label);
        } else {
          _selectedFilters.add(label);
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: isSelected ? mintColor : Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(alignment: Alignment.center, children: [Icon(Icons.menu_book, size: 100, color: mintColor.withOpacity(0.6)), Positioned(top: 0, left: 20, child: Icon(Icons.search, size: 60, color: Colors.amber.shade300))]),
        const SizedBox(height: 30), Text("찾으실 팀 프로젝트를 검색하세요.", style: TextStyle(color: Colors.grey.shade500, fontSize: 15, fontWeight: FontWeight.w600)), const SizedBox(height: 100),
      ],
    );
  }
}