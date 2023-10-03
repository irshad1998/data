import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oxygen/common/extensions.dart';

import 'package:oxygen/widgets/common_fade_in_image.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MyView extends StatefulWidget {
  const MyView({super.key});

  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            20.verticalSpace,
            const LoginTextField(),
          ],
        ),
      )),
    );
  }
}

class LoginTextField extends StatefulWidget {
  const LoginTextField({super.key});

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  Country? initial = Country.fromJson(countryList[0]);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.sw(),
      height: 45.h,
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              Country? v = await showModalBottomSheet<Country?>(
                isScrollControlled: true,
                context: context,
                builder: (ctx) {
                  return const CountryPicker();
                },
              );
              if (v != null) {
                initial = v;
                setState(() {});
              }
            },
            child: Container(
              width: 62.w,
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(width: 0.5, color: const Color(0xffd1d4db)),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 3),
                    color: Color(0xffe7e8e8),
                    blurRadius: 0.5,
                    spreadRadius: -1,
                    blurStyle: BlurStyle.normal,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  6.horizontalSpace,
                  CommonCachedNetworkImageFixed(
                    image: initial?.countryFlag,
                    width: 28.w,
                    height: 18.h,
                    fit: BoxFit.fill,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: const Color(0xffb0b4c0),
                    size: 20.sp,
                  )
                ],
              ),
            ),
          ),
          6.horizontalSpace,
          Container(
            width: context.sw() - (100.w),
            height: 45.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(width: 0.5, color: const Color(0xffd1d4db)),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 3),
                  color: Color(0xffe7e8e8),
                  blurRadius: 0.5,
                  spreadRadius: -1,
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                6.horizontalSpace,
                Text(
                  '+${initial?.countryIsdCode}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xff1c1c1c),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                6.horizontalSpace,
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xff1c1c1c),
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                    ),
                    maxLength: 10,
                    cursorColor: const Color(0xff1c1c1c),
                    cursorWidth: 1,
                    cursorRadius: Radius.circular(10.r),
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CountryPicker extends StatefulWidget {
  const CountryPicker({super.key});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  final List<Country> _countryList = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sh() * 0.975,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverAppBar(
              elevation: 0,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: SizedBox(
                width: context.sw(),
                height: 50.h,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(FeatherIcons.arrowLeft))
                  ],
                ),
              ),
              floating: true,
              toolbarHeight: 50.h,
            ),
            SliverAppBar(
              elevation: 0,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: SizedBox(
                width: context.sw(),
                height: 50.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40.h,
                      width: context.sw() * 0.92,
                      decoration: BoxDecoration(
                        color: const Color(0xffefefef),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          8.horizontalSpace,
                          Icon(
                            FeatherIcons.search,
                            size: 16.sp,
                            color: const Color(0xff616169),
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 3.5.r),
                              child: const TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search your country by name ...',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff616169),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floating: false,
              pinned: true,
              toolbarHeight: 50.h,
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverList.list(children: [
              10.verticalSpace,
              Row(
                children: [
                  16.horizontalSpace,
                  Text(
                    'Select your country',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  width: context.sw(),
                  height: 1,
                  color: const Color(0xfff2f4f6),
                ),
              ),
            ]),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, _countryList[index]);
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: context.sw(),
                      height: 36.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: context.sw(),
                            height: 35.h,
                            child: Row(
                              children: [
                                16.horizontalSpace,
                                CommonCachedNetworkImageFixed(
                                  image: _countryList[index].countryFlag,
                                  width: 28.w,
                                  height: 18.h,
                                  fit: BoxFit.fill,
                                ),
                                10.horizontalSpace,
                                Text(
                                  _countryList[index].countryNameEn ?? '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp),
                                ),
                                const Expanded(child: SizedBox.shrink()),
                                Text(
                                  '+${_countryList[index].countryIsdCode}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp),
                                ),
                                16.horizontalSpace,
                              ],
                            ),
                          ),
                          index != _countryList.length - 1
                              ? Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Container(
                                    width: context.sw(),
                                    height: 1,
                                    color: const Color(0xfff2f4f6),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  );
                },
                childCount: _countryList.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    loadCountryList();
    super.initState();
  }

  void loadCountryList() {
    for (int i = 0; i < countryList.length; i++) {
      try {
        Country country = Country.fromJson(countryList[i]);
        _countryList.add(country);
      } catch (e) {
        break;
      }
    }
  }
}

List<Map<String, dynamic>> countryList = [
  {
    "country_id": 1,
    "country_name_en": "India",
    "country_alpha2_code": "IN",
    "country_alpha3_code": "IND",
    "country_isd_code": "91",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_1.png"
  },
  {
    "country_id": 24,
    "country_name_en": "Benin",
    "country_alpha2_code": "BJ",
    "country_alpha3_code": "BEN",
    "country_isd_code": "229",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_24.png"
  },
  {
    "country_id": 84,
    "country_name_en": "Guatemala",
    "country_alpha2_code": "GT",
    "country_alpha3_code": "GTM",
    "country_isd_code": "502",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_84.png"
  },
  {
    "country_id": 183,
    "country_name_en": "Sierra Leone",
    "country_alpha2_code": "SL",
    "country_alpha3_code": "SLE",
    "country_isd_code": "232",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_183.png"
  },
  {
    "country_id": 214,
    "country_name_en": "UAE",
    "country_alpha2_code": "AE",
    "country_alpha3_code": "ARE",
    "country_isd_code": "971",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_214.png"
  },
  {
    "country_id": 222,
    "country_name_en": "Vietnam",
    "country_alpha2_code": "VN",
    "country_alpha3_code": "VND",
    "country_isd_code": "84",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_222.png"
  },
  {
    "country_id": 64,
    "country_name_en": "Estonia",
    "country_alpha2_code": "EE",
    "country_alpha3_code": "EST",
    "country_isd_code": "372",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_64.png"
  },
  {
    "country_id": 73,
    "country_name_en": "Gabon",
    "country_alpha2_code": "GA",
    "country_alpha3_code": "GAB",
    "country_isd_code": "241",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_73.png"
  },
  {
    "country_id": 118,
    "country_name_en": "Luxembourg",
    "country_alpha2_code": "LU",
    "country_alpha3_code": "LUX",
    "country_isd_code": "352",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_118.png"
  },
  {
    "country_id": 194,
    "country_name_en": "Swaziland",
    "country_alpha2_code": "SZ",
    "country_alpha3_code": "SWZ",
    "country_isd_code": "268",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_194.png"
  },
  {
    "country_id": 202,
    "country_name_en": "Timor-Leste",
    "country_alpha2_code": "TL",
    "country_alpha3_code": "TLS",
    "country_isd_code": "670",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_202.png"
  },
  {
    "country_id": 137,
    "country_name_en": "Montenegro",
    "country_alpha2_code": "ME",
    "country_alpha3_code": "MNE",
    "country_isd_code": "382",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_137.png"
  },
  {
    "country_id": 182,
    "country_name_en": "Seychelles",
    "country_alpha2_code": "SC",
    "country_alpha3_code": "SYC",
    "country_isd_code": "248",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_182.png"
  },
  {
    "country_id": 10,
    "country_name_en": "Antigua and Barbuda",
    "country_alpha2_code": "AG",
    "country_alpha3_code": "ATG",
    "country_isd_code": "1268",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_10.png"
  },
  {
    "country_id": 42,
    "country_name_en": "Chile",
    "country_alpha2_code": "CL",
    "country_alpha3_code": "CHL",
    "country_isd_code": "56",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_42.png"
  },
  {
    "country_id": 51,
    "country_name_en": "Croatia",
    "country_alpha2_code": "HR",
    "country_alpha3_code": "HRV",
    "country_isd_code": "385",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_51.png"
  },
  {
    "country_id": 113,
    "country_name_en": "Lesotho",
    "country_alpha2_code": "LS",
    "country_alpha3_code": "LSO",
    "country_isd_code": "266",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_113.png"
  },
  {
    "country_id": 117,
    "country_name_en": "Lithuania",
    "country_alpha2_code": "LT",
    "country_alpha3_code": "LTU",
    "country_isd_code": "370",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_117.png"
  },
  {
    "country_id": 184,
    "country_name_en": "Singapore",
    "country_alpha2_code": "SG",
    "country_alpha3_code": "SGP",
    "country_isd_code": "65",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_184.png"
  },
  {
    "country_id": 187,
    "country_name_en": "Solomon Islands",
    "country_alpha2_code": "SB",
    "country_alpha3_code": "SLB",
    "country_isd_code": "677",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_187.png"
  },
  {
    "country_id": 11,
    "country_name_en": "Argentina",
    "country_alpha2_code": "AR",
    "country_alpha3_code": "ARG",
    "country_isd_code": "54",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_11.png"
  },
  {
    "country_id": 105,
    "country_name_en": "Kiribati",
    "country_alpha2_code": "KI",
    "country_alpha3_code": "KIR",
    "country_isd_code": "686",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_105.png"
  },
  {
    "country_id": 108,
    "country_name_en": "Kuwait",
    "country_alpha2_code": "KW",
    "country_alpha3_code": "KWT",
    "country_isd_code": "965",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_108.png"
  },
  {
    "country_id": 149,
    "country_name_en": "Nicaragua",
    "country_alpha2_code": "NI",
    "country_alpha3_code": "NIC",
    "country_isd_code": "505",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_149.png"
  },
  {
    "country_id": 179,
    "country_name_en": "Saudi Arabia",
    "country_alpha2_code": "SA",
    "country_alpha3_code": "SAU",
    "country_isd_code": "966",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_179.png"
  },
  {
    "country_id": 26,
    "country_name_en": "Bhutan",
    "country_alpha2_code": "BT",
    "country_alpha3_code": "BTN",
    "country_isd_code": "975",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_26.png"
  },
  {
    "country_id": 30,
    "country_name_en": "Brasil",
    "country_alpha2_code": "BR",
    "country_alpha3_code": "BRA",
    "country_isd_code": "55",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_30.png"
  },
  {
    "country_id": 124,
    "country_name_en": "Maldives",
    "country_alpha2_code": "MV",
    "country_alpha3_code": "MDV",
    "country_isd_code": "960",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_124.png"
  },
  {
    "country_id": 136,
    "country_name_en": "Mongolia",
    "country_alpha2_code": "MN",
    "country_alpha3_code": "MNG",
    "country_isd_code": "976",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_136.png"
  },
  {
    "country_id": 201,
    "country_name_en": "Thailand",
    "country_alpha2_code": "TH",
    "country_alpha3_code": "THA",
    "country_isd_code": "66",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_201.png"
  },
  {
    "country_id": 129,
    "country_name_en": "Mauritania",
    "country_alpha2_code": "MR",
    "country_alpha3_code": "MRT",
    "country_isd_code": "222",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_129.png"
  },
  {
    "country_id": 175,
    "country_name_en": "Saint Vincent and the Grenadines",
    "country_alpha2_code": "VC",
    "country_alpha3_code": "VCT",
    "country_isd_code": "1784",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_175.png"
  },
  {
    "country_id": 180,
    "country_name_en": "Senegal",
    "country_alpha2_code": "SN",
    "country_alpha3_code": "SEN",
    "country_isd_code": "221",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_180.png"
  },
  {
    "country_id": 53,
    "country_name_en": "Cyprus",
    "country_alpha2_code": "CY",
    "country_alpha3_code": "CYP",
    "country_isd_code": "357",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_53.png"
  },
  {
    "country_id": 57,
    "country_name_en": "Dominica",
    "country_alpha2_code": "DM",
    "country_alpha3_code": "DMA",
    "country_isd_code": "1767",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_57.png"
  },
  {
    "country_id": 58,
    "country_name_en": "Dominican Republic",
    "country_alpha2_code": "DO",
    "country_alpha3_code": "DOM",
    "country_isd_code": "18",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_58.png"
  },
  {
    "country_id": 115,
    "country_name_en": "Libya",
    "country_alpha2_code": "LY",
    "country_alpha3_code": "LBY",
    "country_isd_code": "218",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_115.png"
  },
  {
    "country_id": 122,
    "country_name_en": "Malawi",
    "country_alpha2_code": "MW",
    "country_alpha3_code": "MWI",
    "country_isd_code": "265",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_122.png"
  },
  {
    "country_id": 86,
    "country_name_en": "Guinea-Bissau",
    "country_alpha2_code": "GW",
    "country_alpha3_code": "GNB",
    "country_isd_code": "245",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_86.png"
  },
  {
    "country_id": 87,
    "country_name_en": "Guyana",
    "country_alpha2_code": "GY",
    "country_alpha3_code": "GUY",
    "country_isd_code": "592",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_87.png"
  },
  {
    "country_id": 109,
    "country_name_en": "Kyrgyzstan",
    "country_alpha2_code": "KG",
    "country_alpha3_code": "KGZ",
    "country_isd_code": "996",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_109.png"
  },
  {
    "country_id": 123,
    "country_name_en": "Malaysia",
    "country_alpha2_code": "MY",
    "country_alpha3_code": "MYS",
    "country_isd_code": "60",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_123.png"
  },
  {
    "country_id": 219,
    "country_name_en": "Vanuatu",
    "country_alpha2_code": "VU",
    "country_alpha3_code": "VUT",
    "country_isd_code": "678",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_219.png"
  },
  {
    "country_id": 89,
    "country_name_en": "Honduras",
    "country_alpha2_code": "HN",
    "country_alpha3_code": "HND",
    "country_isd_code": "504",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_89.png"
  },
  {
    "country_id": 166,
    "country_name_en": "Qatar",
    "country_alpha2_code": "QA",
    "country_alpha3_code": "QAT",
    "country_isd_code": "974",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_166.png"
  },
  {
    "country_id": 14,
    "country_name_en": "Australia",
    "country_alpha2_code": "AU",
    "country_alpha3_code": "AUS",
    "country_isd_code": "61",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_14.png"
  },
  {
    "country_id": 23,
    "country_name_en": "Belize",
    "country_alpha2_code": "BZ",
    "country_alpha3_code": "BLZ",
    "country_isd_code": "501",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_23.png"
  },
  {
    "country_id": 65,
    "country_name_en": "Ethiopia",
    "country_alpha2_code": "ET",
    "country_alpha3_code": "ETH",
    "country_isd_code": "251",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_65.png"
  },
  {
    "country_id": 135,
    "country_name_en": "Monaco",
    "country_alpha2_code": "MC",
    "country_alpha3_code": "MCO",
    "country_isd_code": "377",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_135.png"
  },
  {
    "country_id": 177,
    "country_name_en": "San Marino",
    "country_alpha2_code": "SM",
    "country_alpha3_code": "SMR",
    "country_isd_code": "378",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_177.png"
  },
  {
    "country_id": 112,
    "country_name_en": "Lebanon",
    "country_alpha2_code": "LB",
    "country_alpha3_code": "LBN",
    "country_isd_code": "961",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_112.png"
  },
  {
    "country_id": 150,
    "country_name_en": "Niger",
    "country_alpha2_code": "NE",
    "country_alpha3_code": "NER",
    "country_isd_code": "227",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_150.png"
  },
  {
    "country_id": 172,
    "country_name_en": "Saint Kitts and Nevis",
    "country_alpha2_code": "KN",
    "country_alpha3_code": "KNA",
    "country_isd_code": "1869",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_172.png"
  },
  {
    "country_id": 215,
    "country_name_en": "United Kingdom",
    "country_alpha2_code": "GB",
    "country_alpha3_code": "GBR",
    "country_isd_code": "44",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_215.png"
  },
  {
    "country_id": 18,
    "country_name_en": "Bahrain",
    "country_alpha2_code": "BH",
    "country_alpha3_code": "BHR",
    "country_isd_code": "973",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_18.png"
  },
  {
    "country_id": 104,
    "country_name_en": "Kenya",
    "country_alpha2_code": "KE",
    "country_alpha3_code": "KEN",
    "country_isd_code": "254",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_104.png"
  },
  {
    "country_id": 127,
    "country_name_en": "Marshall Islands",
    "country_alpha2_code": "MH",
    "country_alpha3_code": "MHL",
    "country_isd_code": "692",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_127.png"
  },
  {
    "country_id": 161,
    "country_name_en": "Peru",
    "country_alpha2_code": "PE",
    "country_alpha3_code": "PER",
    "country_isd_code": "51",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_161.png"
  },
  {
    "country_id": 195,
    "country_name_en": "Sweden",
    "country_alpha2_code": "SE",
    "country_alpha3_code": "SWE",
    "country_isd_code": "46",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_195.png"
  },
  {
    "country_id": 228,
    "country_name_en": "Zimbabwe",
    "country_alpha2_code": "ZW",
    "country_alpha3_code": "ZWE",
    "country_isd_code": "263",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_228.png"
  },
  {
    "country_id": 12,
    "country_name_en": "Armenia",
    "country_alpha2_code": "AM",
    "country_alpha3_code": "ARM",
    "country_isd_code": "374",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_12.png"
  },
  {
    "country_id": 33,
    "country_name_en": "Burkina Faso",
    "country_alpha2_code": "BF",
    "country_alpha3_code": "BFA",
    "country_isd_code": "226",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_33.png"
  },
  {
    "country_id": 36,
    "country_name_en": "Cameroon",
    "country_alpha2_code": "CM",
    "country_alpha3_code": "CMR",
    "country_isd_code": "237",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_36.png"
  },
  {
    "country_id": 155,
    "country_name_en": "Oman",
    "country_alpha2_code": "OM",
    "country_alpha3_code": "OMN",
    "country_isd_code": "968",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_155.png"
  },
  {
    "country_id": 168,
    "country_name_en": "Romania",
    "country_alpha2_code": "RO",
    "country_alpha3_code": "ROU",
    "country_isd_code": "40",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_168.png"
  },
  {
    "country_id": 148,
    "country_name_en": "New Zealand",
    "country_alpha2_code": "NZ",
    "country_alpha3_code": "NZL",
    "country_isd_code": "64",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_148.png"
  },
  {
    "country_id": 154,
    "country_name_en": "Norway",
    "country_alpha2_code": "NO",
    "country_alpha3_code": "NOR",
    "country_isd_code": "47",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_154.png"
  },
  {
    "country_id": 159,
    "country_name_en": "Papua New Guinea",
    "country_alpha2_code": "PG",
    "country_alpha3_code": "PNG",
    "country_isd_code": "675",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_159.png"
  },
  {
    "country_id": 29,
    "country_name_en": "Botswana",
    "country_alpha2_code": "BW",
    "country_alpha3_code": "BWA",
    "country_isd_code": "267",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_29.png"
  },
  {
    "country_id": 88,
    "country_name_en": "Haiti",
    "country_alpha2_code": "HT",
    "country_alpha3_code": "HTI",
    "country_isd_code": "509",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_88.png"
  },
  {
    "country_id": 99,
    "country_name_en": "Italy",
    "country_alpha2_code": "IT",
    "country_alpha3_code": "ITA",
    "country_isd_code": "39",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_99.png"
  },
  {
    "country_id": 116,
    "country_name_en": "Liechtenstein",
    "country_alpha2_code": "LI",
    "country_alpha3_code": "LIE",
    "country_isd_code": "423",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_116.png"
  },
  {
    "country_id": 145,
    "country_name_en": "Netherlands",
    "country_alpha2_code": "NL",
    "country_alpha3_code": "NLD",
    "country_isd_code": "31",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_145.png"
  },
  {
    "country_id": 160,
    "country_name_en": "Paraguay",
    "country_alpha2_code": "PY",
    "country_alpha3_code": "PRY",
    "country_isd_code": "595",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_160.png"
  },
  {
    "country_id": 189,
    "country_name_en": "South Africa",
    "country_alpha2_code": "ZA",
    "country_alpha3_code": "ZAF",
    "country_isd_code": "27",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_189.png"
  },
  {
    "country_id": 192,
    "country_name_en": "Sudan",
    "country_alpha2_code": "SD",
    "country_alpha3_code": "SDN",
    "country_isd_code": "249",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_192.png"
  },
  {
    "country_id": 226,
    "country_name_en": "Yemen",
    "country_alpha2_code": "YE",
    "country_alpha3_code": "YEM",
    "country_isd_code": "967",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_226.png"
  },
  {
    "country_id": 44,
    "country_name_en": "Colombia",
    "country_alpha2_code": "CO",
    "country_alpha3_code": "COL",
    "country_isd_code": "57",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_44.png"
  },
  {
    "country_id": 76,
    "country_name_en": "Germany",
    "country_alpha2_code": "DE",
    "country_alpha3_code": "DEU",
    "country_isd_code": "49",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_76.png"
  },
  {
    "country_id": 156,
    "country_name_en": "Pakistan",
    "country_alpha2_code": "PK",
    "country_alpha3_code": "PAK",
    "country_isd_code": "92",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_156.png"
  },
  {
    "country_id": 157,
    "country_name_en": "Palau",
    "country_alpha2_code": "PW",
    "country_alpha3_code": "PLW",
    "country_isd_code": "680",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_157.png"
  },
  {
    "country_id": 162,
    "country_name_en": "Philippines",
    "country_alpha2_code": "PH",
    "country_alpha3_code": "PHL",
    "country_isd_code": "63",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_162.png"
  },
  {
    "country_id": 28,
    "country_name_en": "Bosnia and Herzegovina",
    "country_alpha2_code": "BA",
    "country_alpha3_code": "BIH",
    "country_isd_code": "387",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_28.png"
  },
  {
    "country_id": 34,
    "country_name_en": "Burundi",
    "country_alpha2_code": "BI",
    "country_alpha3_code": "BDI",
    "country_isd_code": "257",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_34.png"
  },
  {
    "country_id": 56,
    "country_name_en": "Djibouti",
    "country_alpha2_code": "DJ",
    "country_alpha3_code": "DJI",
    "country_isd_code": "253",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_56.png"
  },
  {
    "country_id": 97,
    "country_name_en": "Ireland",
    "country_alpha2_code": "IE",
    "country_alpha3_code": "IRL",
    "country_isd_code": "353",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_97.png"
  },
  {
    "country_id": 98,
    "country_name_en": "Israel",
    "country_alpha2_code": "IL",
    "country_alpha3_code": "ISR",
    "country_isd_code": "972",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_98.png"
  },
  {
    "country_id": 54,
    "country_name_en": "Czech Republic",
    "country_alpha2_code": "CZ",
    "country_alpha3_code": "CZE",
    "country_isd_code": "420",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_54.png"
  },
  {
    "country_id": 59,
    "country_name_en": "Ecuador",
    "country_alpha2_code": "EC",
    "country_alpha3_code": "ECU",
    "country_isd_code": "593",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_59.png"
  },
  {
    "country_id": 77,
    "country_name_en": "Ghana",
    "country_alpha2_code": "GH",
    "country_alpha3_code": "GHA",
    "country_isd_code": "233",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_77.png"
  },
  {
    "country_id": 102,
    "country_name_en": "Jordan",
    "country_alpha2_code": "JO",
    "country_alpha3_code": "JOR",
    "country_isd_code": "962",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_102.png"
  },
  {
    "country_id": 211,
    "country_name_en": "Tuvalu",
    "country_alpha2_code": "TV",
    "country_alpha3_code": "TUV",
    "country_isd_code": "688",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_211.png"
  },
  {
    "country_id": 19,
    "country_name_en": "Bangladesh",
    "country_alpha2_code": "BD",
    "country_alpha3_code": "BGD",
    "country_isd_code": "880",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_19.png"
  },
  {
    "country_id": 20,
    "country_name_en": "Barbados",
    "country_alpha2_code": "BB",
    "country_alpha3_code": "BRB",
    "country_isd_code": "1246",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_20.png"
  },
  {
    "country_id": 38,
    "country_name_en": "Cape Verde",
    "country_alpha2_code": "CV",
    "country_alpha3_code": "CPV",
    "country_isd_code": "238",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_38.png"
  },
  {
    "country_id": 79,
    "country_name_en": "Greece",
    "country_alpha2_code": "GR",
    "country_alpha3_code": "GRC",
    "country_isd_code": "30",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_79.png"
  },
  {
    "country_id": 216,
    "country_name_en": "United States",
    "country_alpha2_code": "US",
    "country_alpha3_code": "USA",
    "country_isd_code": "1",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_216.png"
  },
  {
    "country_id": 60,
    "country_name_en": "Egypt",
    "country_alpha2_code": "EG",
    "country_alpha3_code": "EGY",
    "country_isd_code": "20",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_60.png"
  },
  {
    "country_id": 70,
    "country_name_en": "France",
    "country_alpha2_code": "FR",
    "country_alpha3_code": "FRA",
    "country_isd_code": "33",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_70.png"
  },
  {
    "country_id": 126,
    "country_name_en": "Malta",
    "country_alpha2_code": "MT",
    "country_alpha3_code": "MLT",
    "country_isd_code": "356",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_126.png"
  },
  {
    "country_id": 213,
    "country_name_en": "Ukraine",
    "country_alpha2_code": "UA",
    "country_alpha3_code": "UKR",
    "country_isd_code": "380",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_213.png"
  },
  {
    "country_id": 143,
    "country_name_en": "Nauru",
    "country_alpha2_code": "NR",
    "country_alpha3_code": "NRU",
    "country_isd_code": "674",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_143.png"
  },
  {
    "country_id": 144,
    "country_name_en": "Nepal",
    "country_alpha2_code": "NP",
    "country_alpha3_code": "NPL",
    "country_isd_code": "977",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_144.png"
  },
  {
    "country_id": 186,
    "country_name_en": "Slovenia",
    "country_alpha2_code": "SI",
    "country_alpha3_code": "SVN",
    "country_isd_code": "386",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_186.png"
  },
  {
    "country_id": 191,
    "country_name_en": "Sri Lanka",
    "country_alpha2_code": "LK",
    "country_alpha3_code": "LKA",
    "country_isd_code": "94",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_191.png"
  },
  {
    "country_id": 207,
    "country_name_en": "Tunisia",
    "country_alpha2_code": "TN",
    "country_alpha3_code": "TUN",
    "country_isd_code": "216",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_207.png"
  },
  {
    "country_id": 212,
    "country_name_en": "Uganda",
    "country_alpha2_code": "UG",
    "country_alpha3_code": "UGA",
    "country_isd_code": "256",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_212.png"
  },
  {
    "country_id": 2,
    "country_name_en": "Afganistan",
    "country_alpha2_code": "AF",
    "country_alpha3_code": "AFG",
    "country_isd_code": "93",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_2.png"
  },
  {
    "country_id": 16,
    "country_name_en": "Azerbaijan",
    "country_alpha2_code": "AZ",
    "country_alpha3_code": "AZE",
    "country_isd_code": "994",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_16.png"
  },
  {
    "country_id": 68,
    "country_name_en": "Fiji",
    "country_alpha2_code": "FJ",
    "country_alpha3_code": "FJI",
    "country_isd_code": "679",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_68.png"
  },
  {
    "country_id": 170,
    "country_name_en": "Rwanda",
    "country_alpha2_code": "RW",
    "country_alpha3_code": "RWA",
    "country_isd_code": "250",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_170.png"
  },
  {
    "country_id": 190,
    "country_name_en": "Spain",
    "country_alpha2_code": "ES",
    "country_alpha3_code": "ESP",
    "country_isd_code": "34",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_190.png"
  },
  {
    "country_id": 206,
    "country_name_en": "Trinidad and Tobago",
    "country_alpha2_code": "TT",
    "country_alpha3_code": "TTO",
    "country_isd_code": "1868",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_206.png"
  },
  {
    "country_id": 217,
    "country_name_en": "Uruguay",
    "country_alpha2_code": "UY",
    "country_alpha3_code": "URY",
    "country_isd_code": "598",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_217.png"
  },
  {
    "country_id": 205,
    "country_name_en": "Tonga",
    "country_alpha2_code": "TO",
    "country_alpha3_code": "TON",
    "country_isd_code": "676",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_205.png"
  },
  {
    "country_id": 43,
    "country_name_en": "China",
    "country_alpha2_code": "CN",
    "country_alpha3_code": "CHN",
    "country_isd_code": "86",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_43.png"
  },
  {
    "country_id": 69,
    "country_name_en": "Finland",
    "country_alpha2_code": "FI",
    "country_alpha3_code": "FIN",
    "country_isd_code": "358",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_69.png"
  },
  {
    "country_id": 81,
    "country_name_en": "Grenada",
    "country_alpha2_code": "GD",
    "country_alpha3_code": "GRD",
    "country_isd_code": "1473",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_81.png"
  },
  {
    "country_id": 91,
    "country_name_en": "Hungary",
    "country_alpha2_code": "HU",
    "country_alpha3_code": "HUN",
    "country_isd_code": "36",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_91.png"
  },
  {
    "country_id": 181,
    "country_name_en": "Serbia",
    "country_alpha2_code": "RS",
    "country_alpha3_code": "SRB",
    "country_isd_code": "381",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_181.png"
  },
  {
    "country_id": 32,
    "country_name_en": "Bulgaria",
    "country_alpha2_code": "BG",
    "country_alpha3_code": "BGR",
    "country_isd_code": "359",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_32.png"
  },
  {
    "country_id": 41,
    "country_name_en": "Chad",
    "country_alpha2_code": "TD",
    "country_alpha3_code": "TCD",
    "country_isd_code": "235",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_41.png"
  },
  {
    "country_id": 111,
    "country_name_en": "Latvia",
    "country_alpha2_code": "LV",
    "country_alpha3_code": "LVA",
    "country_isd_code": "371",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_111.png"
  },
  {
    "country_id": 140,
    "country_name_en": "Mozambique",
    "country_alpha2_code": "MZ",
    "country_alpha3_code": "MOZ",
    "country_isd_code": "258",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_140.png"
  },
  {
    "country_id": 151,
    "country_name_en": "Nigeria",
    "country_alpha2_code": "NG",
    "country_alpha3_code": "NGA",
    "country_isd_code": "234",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_151.png"
  },
  {
    "country_id": 6,
    "country_name_en": "Andorra",
    "country_alpha2_code": "AD",
    "country_alpha3_code": "AND",
    "country_isd_code": "376",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_6.png"
  },
  {
    "country_id": 92,
    "country_name_en": "Iceland",
    "country_alpha2_code": "IS",
    "country_alpha3_code": "ISL",
    "country_isd_code": "354",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_92.png"
  },
  {
    "country_id": 132,
    "country_name_en": "Mexico",
    "country_alpha2_code": "MX",
    "country_alpha3_code": "MEX",
    "country_isd_code": "52",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_132.png"
  },
  {
    "country_id": 158,
    "country_name_en": "Panama",
    "country_alpha2_code": "PA",
    "country_alpha3_code": "PAN",
    "country_isd_code": "507",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_158.png"
  },
  {
    "country_id": 227,
    "country_name_en": "Zambia",
    "country_alpha2_code": "ZM",
    "country_alpha3_code": "ZMB",
    "country_isd_code": "260",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_227.png"
  },
  {
    "country_id": 15,
    "country_name_en": "Austria",
    "country_alpha2_code": "AT",
    "country_alpha3_code": "AUT",
    "country_isd_code": "43",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_15.png"
  },
  {
    "country_id": 22,
    "country_name_en": "Belgium",
    "country_alpha2_code": "BE",
    "country_alpha3_code": "BEL",
    "country_isd_code": "32",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_22.png"
  },
  {
    "country_id": 62,
    "country_name_en": "Equatorial Guinea",
    "country_alpha2_code": "GQ",
    "country_alpha3_code": "GNQ",
    "country_isd_code": "240",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_62.png"
  },
  {
    "country_id": 164,
    "country_name_en": "Portugal",
    "country_alpha2_code": "PT",
    "country_alpha3_code": "PRT",
    "country_isd_code": "351",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_164.png"
  },
  {
    "country_id": 208,
    "country_name_en": "Turkey",
    "country_alpha2_code": "TR",
    "country_alpha3_code": "TUR",
    "country_isd_code": "90",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_208.png"
  },
  {
    "country_id": 85,
    "country_name_en": "Guinea",
    "country_alpha2_code": "GN",
    "country_alpha3_code": "GIN",
    "country_isd_code": "224",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_85.png"
  },
  {
    "country_id": 185,
    "country_name_en": "Slovakia",
    "country_alpha2_code": "SK",
    "country_alpha3_code": "SVK",
    "country_isd_code": "421",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_185.png"
  },
  {
    "country_id": 193,
    "country_name_en": "Suriname",
    "country_alpha2_code": "SR",
    "country_alpha3_code": "SUR",
    "country_isd_code": "597",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_193.png"
  },
  {
    "country_id": 4,
    "country_name_en": "Algeria",
    "country_alpha2_code": "DZ",
    "country_alpha3_code": "DZA",
    "country_isd_code": "213",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_4.png"
  },
  {
    "country_id": 37,
    "country_name_en": "Canada",
    "country_alpha2_code": "CA",
    "country_alpha3_code": "CAN",
    "country_isd_code": "1",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_37.png"
  },
  {
    "country_id": 40,
    "country_name_en": "Central African Republic",
    "country_alpha2_code": "CF",
    "country_alpha3_code": "CAF",
    "country_isd_code": "236",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_40.png"
  },
  {
    "country_id": 46,
    "country_name_en": "Congo",
    "country_alpha2_code": "CG",
    "country_alpha3_code": "COG",
    "country_isd_code": "242",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_46.png"
  },
  {
    "country_id": 74,
    "country_name_en": "Gambia",
    "country_alpha2_code": "GM",
    "country_alpha3_code": "GMB",
    "country_isd_code": "220",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_74.png"
  },
  {
    "country_id": 218,
    "country_name_en": "Uzbekistan",
    "country_alpha2_code": "UZ",
    "country_alpha3_code": "UZB",
    "country_isd_code": "998",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_218.png"
  },
  {
    "country_id": 209,
    "country_name_en": "Turkmenistan",
    "country_alpha2_code": "TM",
    "country_alpha3_code": "TKM",
    "country_isd_code": "993",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_209.png"
  },
  {
    "country_id": 17,
    "country_name_en": "Bahamas",
    "country_alpha2_code": "BS",
    "country_alpha3_code": "BHS",
    "country_isd_code": "1242",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_17.png"
  },
  {
    "country_id": 35,
    "country_name_en": "Cambodia",
    "country_alpha2_code": "KH",
    "country_alpha3_code": "KHM",
    "country_isd_code": "855",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_35.png"
  },
  {
    "country_id": 114,
    "country_name_en": "Liberia",
    "country_alpha2_code": "LR",
    "country_alpha3_code": "LBR",
    "country_isd_code": "231",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_114.png"
  },
  {
    "country_id": 163,
    "country_name_en": "Poland",
    "country_alpha2_code": "PL",
    "country_alpha3_code": "POL",
    "country_isd_code": "48",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_163.png"
  },
  {
    "country_id": 178,
    "country_name_en": "Sao Tome and Principe",
    "country_alpha2_code": "ST",
    "country_alpha3_code": "STP",
    "country_isd_code": "239",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_178.png"
  },
  {
    "country_id": 176,
    "country_name_en": "Samoa",
    "country_alpha2_code": "WS",
    "country_alpha3_code": "WSM",
    "country_isd_code": "685",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_176.png"
  },
  {
    "country_id": 196,
    "country_name_en": "Switzerland",
    "country_alpha2_code": "CH",
    "country_alpha3_code": "CHE",
    "country_isd_code": "41",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_196.png"
  },
  {
    "country_id": 3,
    "country_name_en": "Albania",
    "country_alpha2_code": "AL",
    "country_alpha3_code": "ALB",
    "country_isd_code": "355",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_3.png"
  },
  {
    "country_id": 21,
    "country_name_en": "Belarus",
    "country_alpha2_code": "BY",
    "country_alpha3_code": "BLR",
    "country_isd_code": "375",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_21.png"
  },
  {
    "country_id": 52,
    "country_name_en": "Cuba",
    "country_alpha2_code": "CU",
    "country_alpha3_code": "CUB",
    "country_isd_code": "53",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_52.png"
  },
  {
    "country_id": 130,
    "country_name_en": "Mauritius",
    "country_alpha2_code": "MU",
    "country_alpha3_code": "MUS",
    "country_isd_code": "230",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_130.png"
  },
  {
    "country_id": 142,
    "country_name_en": "Namibia",
    "country_alpha2_code": "NA",
    "country_alpha3_code": "NAM",
    "country_isd_code": "264",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_142.png"
  },
  {
    "country_id": 94,
    "country_name_en": "Indonesia",
    "country_alpha2_code": "ID",
    "country_alpha3_code": "IDN",
    "country_isd_code": "62",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_94.png"
  },
  {
    "country_id": 188,
    "country_name_en": "Somalia",
    "country_alpha2_code": "SO",
    "country_alpha3_code": "SOM",
    "country_isd_code": "252",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_188.png"
  },
  {
    "country_id": 61,
    "country_name_en": "El Salvador",
    "country_alpha2_code": "SV",
    "country_alpha3_code": "SLV",
    "country_isd_code": "503",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_61.png"
  },
  {
    "country_id": 96,
    "country_name_en": "Iraq",
    "country_alpha2_code": "IQ",
    "country_alpha3_code": "IRQ",
    "country_isd_code": "964",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_96.png"
  },
  {
    "country_id": 103,
    "country_name_en": "Kazakhstan",
    "country_alpha2_code": "KZ",
    "country_alpha3_code": "KAZ",
    "country_isd_code": "7",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_103.png"
  },
  {
    "country_id": 139,
    "country_name_en": "Morocco",
    "country_alpha2_code": "MA",
    "country_alpha3_code": "MAR",
    "country_isd_code": "212",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_139.png"
  },
  {
    "country_id": 125,
    "country_name_en": "Mali",
    "country_alpha2_code": "ML",
    "country_alpha3_code": "MLI",
    "country_isd_code": "223",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_125.png"
  },
  {
    "country_id": 141,
    "country_name_en": "Myanmar",
    "country_alpha2_code": "MM",
    "country_alpha3_code": "MMR",
    "country_isd_code": "95",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_141.png"
  },
  {
    "country_id": 173,
    "country_name_en": "Saint Lucia",
    "country_alpha2_code": "LC",
    "country_alpha3_code": "LCA",
    "country_isd_code": "1758",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_173.png"
  },
  {
    "country_id": 45,
    "country_name_en": "Comoros",
    "country_alpha2_code": "KM",
    "country_alpha3_code": "COM",
    "country_isd_code": "269",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_45.png"
  },
  {
    "country_id": 63,
    "country_name_en": "Eritrea",
    "country_alpha2_code": "ER",
    "country_alpha3_code": "ERI",
    "country_isd_code": "291",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_63.png"
  },
  {
    "country_id": 75,
    "country_name_en": "Georgia",
    "country_alpha2_code": "GE",
    "country_alpha3_code": "GEO",
    "country_isd_code": "995",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_75.png"
  },
  {
    "country_id": 101,
    "country_name_en": "Japan",
    "country_alpha2_code": "JP",
    "country_alpha3_code": "JPN",
    "country_isd_code": "81",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_101.png"
  },
  {
    "country_id": 121,
    "country_name_en": "Madagascar",
    "country_alpha2_code": "MG",
    "country_alpha3_code": "MDG",
    "country_isd_code": "261",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_121.png"
  },
  {
    "country_id": 49,
    "country_name_en": "Costa Rica",
    "country_alpha2_code": "CR",
    "country_alpha3_code": "CRI",
    "country_isd_code": "506",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_49.png"
  },
  {
    "country_id": 55,
    "country_name_en": "Denmark",
    "country_alpha2_code": "DK",
    "country_alpha3_code": "DNK",
    "country_isd_code": "45",
    "country_flag": "https://b.zmtcdn.com/images/countries/flags/country_55.png"
  },
  {
    "country_id": 100,
    "country_name_en": "Jamaica",
    "country_alpha2_code": "JM",
    "country_alpha3_code": "JAM",
    "country_isd_code": "1876",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_100.png"
  },
  {
    "country_id": 199,
    "country_name_en": "Tajikistan",
    "country_alpha2_code": "TJ",
    "country_alpha3_code": "TJK",
    "country_isd_code": "992",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_199.png"
  },
  {
    "country_id": 203,
    "country_name_en": "Togo",
    "country_alpha2_code": "TG",
    "country_alpha3_code": "TGO",
    "country_isd_code": "228",
    "country_flag":
        "https://b.zmtcdn.com/images/countries/flags/country_203.png"
  }
];

class Country {
  Country({
    this.countryId,
    this.countryNameEn,
    this.countryAlpha2Code,
    this.countryAlpha3Code,
    this.countryIsdCode,
    this.countryFlag,
    this.min,
    this.max,
  });

  Country.fromJson(dynamic json) {
    countryId = json['country_id'];
    countryNameEn = json['country_name_en'];
    countryAlpha2Code = json['country_alpha2_code'];
    countryAlpha3Code = json['country_alpha3_code'];
    countryIsdCode = json['country_isd_code'];
    countryFlag = json['country_flag'];
    min = json['min'];
    max = json['max'];
  }
  int? countryId;
  String? countryNameEn;
  String? countryAlpha2Code;
  String? countryAlpha3Code;
  String? countryIsdCode;
  String? countryFlag;
  int? min;
  int? max;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country_id'] = countryId;
    map['country_name_en'] = countryNameEn;
    map['country_alpha2_code'] = countryAlpha2Code;
    map['country_alpha3_code'] = countryAlpha3Code;
    map['country_isd_code'] = countryIsdCode;
    map['country_flag'] = countryFlag;
    return map;
  }
}
