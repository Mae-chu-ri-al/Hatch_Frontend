import 'package:flutter/material.dart';

class ApplyTeamDialog extends StatelessWidget {
  final Function(String, String)? onApplyDone;
  final String title;
  final String category;

  const ApplyTeamDialog({Key? key, this.onApplyDone, required this.title, required this.category}) : super(key: key);

  final Color mintColor = const Color(0xFFBCE0D8);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity, height: 400, padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, size: 28)),
                const SizedBox(width: 15), const Text("팀원 신청", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 35),

            TextField(decoration: InputDecoration(hintText: "희망 역할 (예: 프론트엔드)", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15), focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87, width: 2)), isDense: true)),
            const SizedBox(height: 25),
            Expanded(child: TextField(maxLines: null, decoration: InputDecoration(hintText: "어필할 내용을 자유롭게 적어주세요!", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15), border: InputBorder.none))),

            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  //부모로 쏘는 신호에 제목과 카테고리를 실어 보냄.
                  if (onApplyDone != null) {
                    onApplyDone!(title, category);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(children: [Icon(Icons.check_circle, color: Colors.white), SizedBox(width: 10), Text("성공적으로 신청완료 되었습니다!", style: TextStyle(fontWeight: FontWeight.bold))]),
                      backgroundColor: Colors.teal.shade400, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: mintColor, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: const Text("신청하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}