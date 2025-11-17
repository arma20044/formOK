// ----------------- APP VERSION -----------------
class AppVersion {
  final String version;
  final String fecha;

  const AppVersion({required this.version, required this.fecha});
}

class AppVersions {
  final AppVersion ios;
  final AppVersion android;
  final AppVersion windows;
  final AppVersion macos;
  final AppVersion web;

  const AppVersions({
    required this.ios,
    required this.android,
    required this.windows,
    required this.macos,
    required this.web,
  });
}

// ----------------- ENVIRONMENT -----------------
class EnvironmentConfig {
  final String name;
  final String clientKey;
  final String hostSitioAnde;
  final String hostCtxSiga;
  final String hostCtxSara;
  final String hostCtxGra;
  final String hostCtxOpen;
  final String hostCtxGc;
  final String hostCtxMiCuenta;
  final String hostCtxAndroid;
  final String tigoCallback;
  final String keyGoogleMaps;
  final String hostCtxRegistroUnico;
  final AppVersions appVersion;
  final String mensajeErrorRequestStatus;
  final String mensajeErrorRequestGrave;

  const EnvironmentConfig({
    required this.name,
    required this.clientKey,
    required this.hostSitioAnde,
    required this.hostCtxSiga,
    required this.hostCtxSara,
    required this.hostCtxGra,
    required this.hostCtxOpen,
    required this.hostCtxGc,
    required this.hostCtxMiCuenta,
    required this.hostCtxAndroid,
    required this.tigoCallback,
    required this.keyGoogleMaps,
    required this.hostCtxRegistroUnico,
    required this.appVersion,
    required this.mensajeErrorRequestStatus,
    required this.mensajeErrorRequestGrave,
  });
}

// ----------------- DATA -----------------

const appVersions = AppVersions(
  ios: AppVersion(version: "1.3.15", fecha: "18/07/2025"),
  android: AppVersion(version: "4.2.16", fecha: "17/09/2025"),
  windows: AppVersion(version: "0.0.0", fecha: "10/06/2022"),
  macos: AppVersion(version: "0.0.0", fecha: "10/06/2022"),
  web: AppVersion(version: "0.0.0", fecha: "10/06/2022"),
);

const Environments = {
  "produccion": EnvironmentConfig(
    name: "produccion",
    clientKey: "19fec632c1c0f45372ce62dd525addc1437d3b74",
    hostSitioAnde: "https://www.ande.gov.py/servicios",
    hostCtxSiga: "https://prod2.ande.gov.py:8581/sigaWs/api/siga",
    hostCtxSara: "https://prod1.ande.gov.py:8581/sigaWs/api/sara",
    hostCtxGra: "https://prod1.ande.gov.py:8581/sigaWs/api/gra",
    hostCtxOpen: "https://prod2.ande.gov.py:8581/sigaWs/api/open",
    hostCtxGc: "https://prod1.ande.gov.py:8581/sigaWs/api/gc",
    hostCtxMiCuenta: "https://prod2.ande.gov.py:8581/sigaWs/api/miCuenta",
    hostCtxAndroid: "https://prod1.ande.gov.py:8581/sigaWs/api/android",
    tigoCallback: "https://www.ande.gov.py/desarrollo/servicios/tigoMoney.html",
    keyGoogleMaps: "AIzaSyBZgldJmaElcgbgWVt8gFBrdsybsMIKHVg",
    hostCtxRegistroUnico: "https://prod2.ande.gov.py:8581/sigaWs/api/registroUnico",
    appVersion: appVersions,
    mensajeErrorRequestStatus: "No se pudo realizar la acción, intente de nuevo.",
    mensajeErrorRequestGrave: "NO se pudo realizar la acción, intente de nuevo.",
  ),

  "desarrollo": EnvironmentConfig(
    name: "desarrollo",
    clientKey: "19fec632c1c0f45372ce62dd525addc1437d3b74",
    hostSitioAnde: "https://www.ande.gov.py/desarrollo/servicios",
    hostCtxSiga: "https://desa1.ande.gov.py:8481/sigaWs/api/siga",
    hostCtxSara: "https://desa1.ande.gov.py:8481/sigaWs/api/sara",
    hostCtxGra: "https://desa1.ande.gov.py:8481/sigaWs/api/gra",
    hostCtxOpen: "https://desa1.ande.gov.py:8481/sigaWs/api/open",
    hostCtxGc: "https://desa1.ande.gov.py:8481/gcWs/api/gc",
    hostCtxMiCuenta: "https://desa1.ande.gov.py:8481/sigaWs/api/miCuenta",
    hostCtxAndroid: "https://desa1.ande.gov.py:8481/sigaWs/api/android",
    tigoCallback: "https://www.ande.gov.py/desarrollo/servicios/tigoMoney.html",
    keyGoogleMaps: "AIzaSyBZgldJmaElcgbgWVt8gFBrdsybsMIKHVg",
    hostCtxRegistroUnico: "https://desa1.ande.gov.py:8481/sigaWs/api/registroUnico",
    appVersion: appVersions,
    mensajeErrorRequestStatus: "No se pudo realizar la acción, intente de nuevo.",
    mensajeErrorRequestGrave: "NO se pudo realizar la acción, intente de nuevo.",
  ),
  // ⚡️ Puedes agregar localhost y localhostEmulador igual que arriba
};

// ----------------- USO -----------------
const String environmentActual = "desarrollo";

final EnvironmentConfig Environment = Environments[environmentActual]!;

