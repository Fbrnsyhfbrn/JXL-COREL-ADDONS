#include <windows.h>
#include <commdlg.h>
#include <comdef.h>
#include <string>
#include <fstream>
#include <filesystem>
#include <stdexcept>
#include <new>
#import "VGCoreAuto.tlb" rename("GetCommandLine", "VGGetCommandLine") rename("CopyFile", "VGCopyFile") rename("FindWindow", "VGFindWindow") rename("GetObject", "VGGetObject")
namespace fs=std::filesystem;
static HMODULE module;
static void log(const std::wstring& s) noexcept { try { wchar_t p[32768]; if(!GetEnvironmentVariableW(L"LOCALAPPDATA",p,32768)) return; fs::path d=fs::path(p)/L"JXLNovorius"; fs::create_directories(d); std::wofstream f(d/L"startup.log",std::ios::app); f<<s<<L"\n"; }catch(...){} }
// Use explicit wide Win32 API, independent of TCHAR build settings.
static void logComError(const _com_error& e) noexcept {
 try {
  wchar_t message[1024] = {};
  const DWORD code = static_cast<DWORD>(e.Error());
  FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
                 nullptr, code, 0, message, 1024, nullptr);
  log(std::wstring(L"COM HRESULT ") + std::to_wstring(code) + L": " + message);
 } catch (...) {}
}
static fs::path home(){wchar_t p[32768]; GetModuleFileNameW(module,p,32768);return fs::path(p).parent_path();}
class Plugin final: public VGCore::IVGAppPlugin {
 LONG refs=1; VGCore::IVGApplicationPtr app;
 public:
 HRESULT STDMETHODCALLTYPE QueryInterface(REFIID id,void** out) override {if(!out)return E_POINTER;*out=nullptr;if(id==IID_IUnknown||id==IID_IDispatch||id==__uuidof(VGCore::IVGAppPlugin)){*out=static_cast<VGCore::IVGAppPlugin*>(this);AddRef();return S_OK;}return E_NOINTERFACE;}
 ULONG STDMETHODCALLTYPE AddRef() override{return InterlockedIncrement(&refs);} ULONG STDMETHODCALLTYPE Release() override{auto n=InterlockedDecrement(&refs);if(!n)delete this;return n;}
 HRESULT STDMETHODCALLTYPE GetTypeInfoCount(UINT* n) override{if(!n)return E_POINTER;*n=0;return S_OK;} HRESULT STDMETHODCALLTYPE GetTypeInfo(UINT,LCID,ITypeInfo**) override{return E_NOTIMPL;} HRESULT STDMETHODCALLTYPE GetIDsOfNames(REFIID,LPOLESTR*,UINT,LCID,DISPID*) override{return DISP_E_UNKNOWNNAME;}
 HRESULT STDMETHODCALLTYPE Invoke(DISPID,REFIID,LCID,WORD,DISPPARAMS*,VARIANT*,EXCEPINFO*,UINT*) override {return S_OK;}
 HRESULT STDMETHODCALLTYPE raw_OnLoad(VGCore::IVGApplication* a) override {app=a;log(L"OnLoad");return S_OK;}
 HRESULT STDMETHODCALLTYPE raw_StartSession() override {
  log(L"StartSession");
  try {
   auto fw=app->FrameWork;
   _bstr_t id(L"859ee77f-8d38-45d5-9658-969f73ae8f7f");
   try {fw->ShowDocker(id); if(fw->IsDockerVisible(id)){log(L"Existing docker visible");return S_OK;}} catch(const _com_error& e){logComError(e);}
   try {fw->AddDocker(id,_bstr_t(L"JXLNovorius.DockerUI"),_bstr_t((home()/L"JXLNovorius.Addon.dll").c_str()));log(L"AddDocker returned");} catch(const _com_error& e){logComError(e);}
   fw->ShowDocker(id);
   log(fw->IsDockerVisible(id)?L"Docker visible":L"Docker not visible");
  }catch(const _com_error& e){logComError(e);}catch(...){log(L"Startup exception");}
  return S_OK;
 }
 HRESULT STDMETHODCALLTYPE raw_StopSession() override {log(L"StopSession");return S_OK;}
 HRESULT STDMETHODCALLTYPE raw_OnUnload() override {app=nullptr;log(L"OnUnload");return S_OK;}

};
BOOL WINAPI DllMain(HINSTANCE h,DWORD reason,LPVOID){if(reason==DLL_PROCESS_ATTACH)module=h;return TRUE;}
extern "C" __declspec(dllexport) DWORD APIENTRY AttachPlugin(VGCore::IVGAppPlugin** out){if(!out)return 0;*out=new(std::nothrow) Plugin;log(L"AttachPlugin");return *out?0x100:0;}
