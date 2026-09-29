/// Android 原生隐私合规配置
///
/// 对应 Android SDK 的 `OSETCustomController`，用于在初始化广告 SDK 之前声明
/// 允许 / 禁止 SDK 主动采集哪些设备信息，是《个人信息保护法》《App 违法违规
/// 收集使用个人信息行为认定方法》等合规检查的必填项。
///
/// * 该配置**仅在 Android 生效**，iOS 端会忽略；
/// * 所有开关默认与 Android SDK 保持一致（默认允许）；
/// * 被置为 `false` 的信息，SDK 不再主动采集，如需继续使用可自行传入
///   （例如 [imei]、[oaid]、[androidId]、[latitude]/[longitude]、
///   [installedPackages]）；
/// * 必须在初始化前确定，即随 [OSETAdSDK.initAd] 一次性传入。
///
/// 使用示例：
/// ```dart
/// final bool ok = await OSETAdSDK.initAd(
///   appKey: 'YOUR_APP_KEY',
///   debug: false,
///   privacyConfig: OSETPrivacyConfig(
///     canUsePersonalizedAd: false, // 关闭个性化广告
///     canUsePhoneState: false,
///     canUseOaid: false,
///     canReadLocation: false,
///   ),
/// );
/// ```
class OSETPrivacyConfig {
  /// 是否允许 SDK 主动使用地理位置信息，默认 true。
  ///
  /// 置为 false 时，可通过 [latitude] / [longitude] 传入地理位置信息。
  bool canReadLocation;

  /// [canReadLocation] 为 false 时，SDK 使用这里传入的纬度。
  double? latitude;

  /// [canReadLocation] 为 false 时，SDK 使用这里传入的经度。
  double? longitude;

  /// 是否允许 SDK 主动使用手机硬件参数（imei、meid、imsi、iccid），默认 true。
  ///
  /// 置为 false 时，可通过 [imei] 传入。
  bool canUsePhoneState;

  /// [canUsePhoneState] 为 false 时，SDK 使用这里传入的原始 imei。
  ///
  /// 注意：请传入原始 imei 值，无需 md5 加密，SDK 整体信息加密传输已满足合规需要。
  String? imei;

  /// 是否允许 SDK 主动读取 androidId，默认 true。
  ///
  /// 置为 false 时，可通过 [androidId] 传入。
  bool canUseAndroidId;

  /// [canUseAndroidId] 为 false 时，SDK 使用这里传入的 androidId。
  String? androidId;

  /// 是否允许 SDK 主动使用 oaid，默认 true。
  ///
  /// 置为 false 时，可通过 [oaid] 传入。
  bool canUseOaid;

  /// [canUseOaid] 为 false 时，SDK 使用这里传入的原始 oaid。
  ///
  /// 注意：请传入原始 oaid，无需 md5 加密，SDK 整体信息加密传输已满足合规需要。
  String? oaid;

  /// 是否允许 SDK 主动使用 `ACCESS_NETWORK_STATE` 权限，默认 true。
  bool canUseNetworkState;

  /// 是否允许 SDK 主动使用存储权限，默认 true。
  bool canUseStoragePermission;

  /// 是否允许 SDK 主动读取 App 安装列表，默认 true。
  ///
  /// 置为 false 时，可通过 [installedPackages] 传入。
  bool canReadInstalledPackages;

  /// [canReadInstalledPackages] 为 false 时，SDK 使用这里传入的安装列表。
  List<String>? installedPackages;

  /// 是否启用个性化广告，默认 true。
  ///
  /// 置为 false 表示不投放个性化广告。
  bool canUsePersonalizedAd;

  /// 是否允许 SDK 主动使用传感器，默认 true。
  bool canUseSensor;

  OSETPrivacyConfig({
    this.canReadLocation = true,
    this.latitude,
    this.longitude,
    this.canUsePhoneState = true,
    this.imei,
    this.canUseAndroidId = true,
    this.androidId,
    this.canUseOaid = true,
    this.oaid,
    this.canUseNetworkState = true,
    this.canUseStoragePermission = true,
    this.canReadInstalledPackages = true,
    this.installedPackages,
    this.canUsePersonalizedAd = true,
    this.canUseSensor = true,
  });

  /// 复制并覆盖部分字段（注意：无法把字段重置为 null）
  OSETPrivacyConfig copyWith({
    bool? canReadLocation,
    double? latitude,
    double? longitude,
    bool? canUsePhoneState,
    String? imei,
    bool? canUseAndroidId,
    String? androidId,
    bool? canUseOaid,
    String? oaid,
    bool? canUseNetworkState,
    bool? canUseStoragePermission,
    bool? canReadInstalledPackages,
    List<String>? installedPackages,
    bool? canUsePersonalizedAd,
    bool? canUseSensor,
  }) {
    return OSETPrivacyConfig(
      canReadLocation: canReadLocation ?? this.canReadLocation,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      canUsePhoneState: canUsePhoneState ?? this.canUsePhoneState,
      imei: imei ?? this.imei,
      canUseAndroidId: canUseAndroidId ?? this.canUseAndroidId,
      androidId: androidId ?? this.androidId,
      canUseOaid: canUseOaid ?? this.canUseOaid,
      oaid: oaid ?? this.oaid,
      canUseNetworkState: canUseNetworkState ?? this.canUseNetworkState,
      canUseStoragePermission:
          canUseStoragePermission ?? this.canUseStoragePermission,
      canReadInstalledPackages:
          canReadInstalledPackages ?? this.canReadInstalledPackages,
      installedPackages: installedPackages ?? this.installedPackages,
      canUsePersonalizedAd: canUsePersonalizedAd ?? this.canUsePersonalizedAd,
      canUseSensor: canUseSensor ?? this.canUseSensor,
    );
  }

  /// 转换为传给原生端的参数，null 的字段不会下发，由原生回落到 SDK 默认值
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'canReadLocation': canReadLocation,
      'canUsePhoneState': canUsePhoneState,
      'canUseAndroidId': canUseAndroidId,
      'canUseOaid': canUseOaid,
      'canUseNetworkState': canUseNetworkState,
      'canUseStoragePermission': canUseStoragePermission,
      'canReadInstalledPackages': canReadInstalledPackages,
      'canUsePersonalizedAd': canUsePersonalizedAd,
      'canUseSensor': canUseSensor,
    };
    if (latitude != null) map['latitude'] = latitude;
    if (longitude != null) map['longitude'] = longitude;
    if (imei != null) map['imei'] = imei;
    if (androidId != null) map['androidId'] = androidId;
    if (oaid != null) map['oaid'] = oaid;
    if (installedPackages != null) {
      map['installedPackages'] = installedPackages;
    }
    return map;
  }

  @override
  String toString() {
    return 'OSETPrivacyConfig${toMap()}';
  }
}
