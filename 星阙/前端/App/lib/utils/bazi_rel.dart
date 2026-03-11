import 'package:horosa/constants/constant.dart';
import 'package:horosa/models/horosa.dart';

class BaZiRelUtil {
  static List<String> getBaZiStemRel(stems) {
    List<List<StemsOrBranchElement>> getStemsPermutation() {
      List<List<StemsOrBranchElement>> permutation = [];
      for (int i = 0; i < stems.length; i++) {
        for (int j = i + 1; j < stems.length; j++) {
          permutation.add([stems[i], stems[j]]);
        }
      }
      return permutation;
    }

    List<List<StemsOrBranchElement>> stemsNatalPermutation = getStemsPermutation();
    return stemsNatalPermutation.map((s) {
      return Stems.complexRelation((s[0] as Stems), (s[1] as Stems));
    }).where((r) => r.isNotEmpty).toSet().toList();
  }

  // 没有【克】关系
  static List<String> getBaZiStemRelWithoutControl(stems) {
    List<List<StemsOrBranchElement>> getStemsPermutation() {
      List<List<StemsOrBranchElement>> permutation = [];
      for (int i = 0; i < stems.length; i++) {
        for (int j = i + 1; j < stems.length; j++) {
          permutation.add([stems[i], stems[j]]);
        }
      }
      return permutation;
    }

    List<List<StemsOrBranchElement>> stemsNatalPermutation = getStemsPermutation();
    return stemsNatalPermutation.map((s) {
      return Stems.complexRelation((s[0] as Stems), (s[1] as Stems), false);
    }).where((r) => r.isNotEmpty).toSet().toList();
  }

  static List<String> getBaZiBranchRel(branches) {
    List<String> res = [];
    // 分组函数
    List<List<StemsOrBranchElement>> getCombinations(List<StemsOrBranchElement> arr, int len, int start, List<StemsOrBranchElement> currentCombo) {
      List<List<StemsOrBranchElement>> combinations = [];

      if (currentCombo.length == len) {
        return [List.from(currentCombo)];  // 直接返回当前组合
      }

      for (int i = start; i < arr.length; i++) {
        currentCombo.add(arr[i]);
        combinations.addAll(getCombinations(arr, len, i + 1, currentCombo));
        currentCombo.removeLast(); // 回溯
      }

      return combinations;
    }

    List<List<StemsOrBranchElement>> branchPermutation = getCombinations(branches, 2, 0, []);
    // 本命
    List<String> complexBranchRelation = branchPermutation.map((s) {
      return Branches.complexRelation((s[0] as Branches), (s[1] as Branches));
    }).where((r) => r.isNotEmpty).toSet().toList();
    res.addAll(complexBranchRelation);

    List<List<StemsOrBranchElement>> branchCombinations = getCombinations(branches, 3, 0, []);
    // 三合
    List<String> calcThreeCombination() {
      List<String> result = [];
      for (var combination in branchCombinations) {
        String key = combination.map((c) => c.label).join('');
        String? value = threeCombinationsMap[key];
        if (value != null) {
          result.add(value);
        } else {
          List<List<StemsOrBranchElement>> subCombs = getCombinations(combination, 2, 0, []);
          for (var sc in subCombs) {
            String subKey = sc.map((c) => c.label).join('');
            String? subValue = threeCombinationsMap[subKey];
            if (subValue != null) {
              result.add(subValue);
            }
          }
        }
      }

      return result;
    }

    List<String> threeCombinationsResult = calcThreeCombination().toSet().toList();
    res.addAll(threeCombinationsResult);

    // 三会
    List<String> calcThreeMeeting() {
      List<String> result = [];
      for (var combination in branchCombinations) {
        String key = combination.map((c) => c.label).join('');
        String? value = threeMeetingsMap[key];
        if (value != null) {
          result.add(value);
        } else {
          List<List<StemsOrBranchElement>> subCombs = getCombinations(combination, 2, 0, []);
          for (var sc in subCombs) {
            String subKey = sc.map((c) => c.label).join('');
            String? subValue = threeMeetingsMap[subKey];
            if (subValue != null) {
              result.add(subValue);
            }
          }
        }
      }

      return result;
    }

    List<String> threeMeetingsResult = calcThreeMeeting().toSet().toList();
    res.addAll(threeMeetingsResult);

    // 暗合
    List<String> calcSecretCombination() {
      List<List<StemsOrBranchElement>> combinations = getCombinations(branches, 2, 0, []);
      List<String> result = [];
      for (var combination in combinations) {
        String key = combination.map((c) => c.label).join('');
        String? value = secretCombinationsMap[key];
        if (value != null) {
          result.add(value);
        }
      }
      return result;
    }

    List<String> secretCombinationsResult = calcSecretCombination().toSet().toList();
    res.addAll(secretCombinationsResult);

    // 暗会
    List<String> calcSecretMeeting() {
      List<List<StemsOrBranchElement>> combinations = getCombinations(branches, 2, 0, []);
      List<String> result = [];
      for (var combination in combinations) {
        String key = combination.map((c) => c.label).join('');
        String? value = secretMeetingsMap[key];
        if (value != null) {
          result.add(value);
        }
      }
      return result;
    }

    List<String> secretMeetingsResult = calcSecretMeeting().toSet().toList();
    res.addAll(secretMeetingsResult);

    // 相刑
    List<String> calcPunishments() {
      List<List<StemsOrBranchElement>> combinations = getCombinations(branches, 2, 0, []);
      List<String> result = [];
      for (var combination in combinations) {
        String key = combination.map((c) => c.label).join('');
        String? value = punishmentsMap[key];
        if (value != null) {
          result.add(value);
        }
      }
      return result;
    }

    List<String> punishmentsResult = calcPunishments().toSet().toList();
    res.addAll(punishmentsResult);

    // 相害
    List<String> calcHarms() {
      List<List<StemsOrBranchElement>> combinations = getCombinations(branches, 2, 0, []);
      List<String> result = [];
      for (var combination in combinations) {
        String key = combination.map((c) => c.label).join('');
        String? value = harmsMap[key];
        if (value != null) {
          result.add(value);
        }
      }
      return result;
    }

    List<String> harmsResult = calcHarms().toSet().toList();
    res.addAll(harmsResult);

    // 相破
    List<String> calcDestruction() {
      List<List<StemsOrBranchElement>> combinations = getCombinations(branches, 2, 0, []);
      List<String> result = [];
      for (var combination in combinations) {
        String key = combination.map((c) => c.label).join('');
        String? value = destructionMap[key];
        if (value != null) {
          result.add(value);
        }
      }
      return result;
    }
    List<String> destructionResult = calcDestruction().toSet().toList();
    res.addAll(destructionResult);

    return res;
  }
}

class Natal {

}

class Detailed {

}