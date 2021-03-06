function [methodinfo,structs,enuminfo,ThunkLibName]=TMSiHeader64
%TMSIHEADER Create structures to define interfaces found in 'TMSiSDK'.

%This function was generated by loadlibrary.m parser version  on Mon Mar  7 13:03:42 2016
%perl options:'TMSiSDK.i -outfile=TMSiHeader.m -thunkfile=TMSiSDK_thunk_pcwin64.c -header=TMSiSDK.h'
ival={cell(1,0)}; % change 0 to the actual number of functions to preallocate the data.
structs=[];enuminfo=[];fcnNum=1;
fcns=struct('name',ival,'calltype',ival,'LHS',ival,'RHS',ival,'alias',ival,'thunkname', ival);
MfilePath=fileparts(mfilename('fullpath'));
ThunkLibName=fullfile(MfilePath,'TMSiSDK_thunk_pcwin64');
% BOOLEAN __stdcall SetRtcTime ( HANDLE Handle , SYSTEMTIME * InTime ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrThunk';fcns.name{fcnNum}='SetRtcTime'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 's_SYSTEMTIMEPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetRtcTime ( HANDLE Handle , SYSTEMTIME * InTime ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrThunk';fcns.name{fcnNum}='GetRtcTime'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 's_SYSTEMTIMEPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetRtcAlarmTime ( HANDLE Handle , SYSTEMTIME * InTime , BOOLEAN AlarmOnOff ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtruint8Thunk';fcns.name{fcnNum}='SetRtcAlarmTime'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 's_SYSTEMTIMEPtr', 'uint8'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetRtcAlarmTime ( HANDLE Handle , SYSTEMTIME * InTime , BOOLEAN * AlarmOnOff ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='GetRtcAlarmTime'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 's_SYSTEMTIMEPtr', 'uint8Ptr'};fcnNum=fcnNum+1;
% int __stdcall TMSISendDataBlock ( HANDLE Handle , int KeyCode , unsigned short BlockType , unsigned short NrOfShorts , const short * const InBuffer , unsigned short ExpectedBlockType ); 
fcns.thunkname{fcnNum}='int32voidPtrint32uint16uint16voidPtruint16Thunk';fcns.name{fcnNum}='TMSISendDataBlock'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'voidPtr', 'int32', 'uint16', 'uint16', 'int16Ptr', 'uint16'};fcnNum=fcnNum+1;
% HANDLE __stdcall LibraryInit ( TMSiConnectionType GivenConnectionType , int * ErrorCode ); 
fcns.thunkname{fcnNum}='voidPtrTMSiConnectionTypevoidPtrThunk';fcns.name{fcnNum}='LibraryInit'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='voidPtr'; fcns.RHS{fcnNum}={'e_TMSiConnectionEnum', 'int32Ptr'};fcnNum=fcnNum+1;
% int __stdcall LibraryExit ( HANDLE Handle ); 
fcns.thunkname{fcnNum}='int32voidPtrThunk';fcns.name{fcnNum}='LibraryExit'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetFrontEndInfo ( HANDLE Handle , FRONTENDINFO * FrontEndInfo ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrThunk';fcns.name{fcnNum}='GetFrontEndInfo'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 's_FRONTENDINFOPtr'};fcnNum=fcnNum+1;
% int __stdcall GetErrorCode ( HANDLE Handle ) ; 
fcns.thunkname{fcnNum}='int32voidPtrThunk';fcns.name{fcnNum}='GetErrorCode'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% const char * __stdcall GetErrorCodeMessage ( HANDLE Handle , int id ); 
fcns.thunkname{fcnNum}='cstringvoidPtrint32Thunk';fcns.name{fcnNum}='GetErrorCodeMessage'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='cstring'; fcns.RHS{fcnNum}={'voidPtr', 'int32'};fcnNum=fcnNum+1;
% TMSiFileInfoType * __stdcall GetCardFileList ( void * Handle , int * NrOfFiles ); 
fcns.thunkname{fcnNum}='voidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='GetCardFileList'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='TMSiFileInfoPtr'; fcns.RHS{fcnNum}={'voidPtr', 'int32Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall OpenCardFile ( void * Handle , unsigned short FileId , TMSiFileHeaderType * FileHeader ); 
fcns.thunkname{fcnNum}='uint8voidPtruint16voidPtrThunk';fcns.name{fcnNum}='OpenCardFile'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'uint16', 'TMSiTDFHeaderPtr'};fcnNum=fcnNum+1;
% PSIGNAL_FORMAT __stdcall GetCardFileSignalFormat ( HANDLE Handle ); 
fcns.thunkname{fcnNum}='voidPtrvoidPtrThunk';fcns.name{fcnNum}='GetCardFileSignalFormat'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='s_SIGNAL_FORMATPtr'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetRecordingConfiguration ( void * Handle , TMSiRecordingConfigType * RecordingConfig , unsigned int * ChannelConfig , unsigned int NrOfChannels ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrvoidPtruint32Thunk';fcns.name{fcnNum}='SetRecordingConfiguration'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'TMSiRecordingConfigPtr', 'uint32Ptr', 'uint32'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetRecordingConfiguration ( void * Handle , TMSiRecordingConfigType * RecordingConfig , unsigned int * ChannelConfig , unsigned int * NrOfChannels ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='GetRecordingConfiguration'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'TMSiRecordingConfigPtr', 'uint32Ptr', 'uint32Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall ResetDevice ( HANDLE Handle ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='ResetDevice'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall Open ( void * Handle , const char * DeviceLocator ); 
fcns.thunkname{fcnNum}='uint8voidPtrcstringThunk';fcns.name{fcnNum}='Open'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'cstring'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall Close ( HANDLE hHandle ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='Close'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall Start ( HANDLE Handle ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='Start'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall Stop ( HANDLE Handle ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='Stop'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetSignalBuffer ( HANDLE Handle , PULONG SampleRate , PULONG BufferSize ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='SetSignalBuffer'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'ulongPtr', 'ulongPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetBufferInfo ( HANDLE Handle , PULONG Overflow , PULONG PercentFull ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='GetBufferInfo'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'ulongPtr', 'ulongPtr'};fcnNum=fcnNum+1;
% LONG __stdcall GetSamples ( HANDLE Handle , PULONG SampleBuffer , ULONG Size ); 
fcns.thunkname{fcnNum}='longvoidPtrvoidPtrulongThunk';fcns.name{fcnNum}='GetSamples'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}={'voidPtr', 'ulongPtr', 'ulong'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall DeviceFeature ( HANDLE Handle , LPVOID DataIn , DWORD InSize , LPVOID DataOut , DWORD OutSize ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrulongvoidPtrulongThunk';fcns.name{fcnNum}='DeviceFeature'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'voidPtr', 'ulong', 'voidPtr', 'ulong'};fcnNum=fcnNum+1;
% PSIGNAL_FORMAT __stdcall GetSignalFormat ( HANDLE Handle , char * FrontEndName ); 
fcns.thunkname{fcnNum}='voidPtrvoidPtrcstringThunk';fcns.name{fcnNum}='GetSignalFormat'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='s_SIGNAL_FORMATPtr'; fcns.RHS{fcnNum}={'voidPtr', 'cstring'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall Free ( void * Memory ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='Free'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% HANDLE __stdcall LibraryInit ( TMSiConnectionType GivenConnectionType , int * ErrorCode ); 
fcns.thunkname{fcnNum}='voidPtrTMSiConnectionTypevoidPtrThunk';fcns.name{fcnNum}='LibraryInit'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='voidPtr'; fcns.RHS{fcnNum}={'e_TMSiConnectionEnum', 'int32Ptr'};fcnNum=fcnNum+1;
% int __stdcall LibraryExit ( HANDLE Handle ); 
fcns.thunkname{fcnNum}='int32voidPtrThunk';fcns.name{fcnNum}='LibraryExit'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetFrontEndInfo ( HANDLE Handle , FRONTENDINFO * FrontEndInfo ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrThunk';fcns.name{fcnNum}='GetFrontEndInfo'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 's_FRONTENDINFOPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetRtcTime ( HANDLE Handle , SYSTEMTIME * InTime ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrThunk';fcns.name{fcnNum}='SetRtcTime'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 's_SYSTEMTIMEPtr'};fcnNum=fcnNum+1;
% int __stdcall GetErrorCode ( HANDLE Handle ); 
fcns.thunkname{fcnNum}='int32voidPtrThunk';fcns.name{fcnNum}='GetErrorCode'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% const char * __stdcall GetErrorCodeMessage ( HANDLE Handle , int ErrorCode ); 
fcns.thunkname{fcnNum}='cstringvoidPtrint32Thunk';fcns.name{fcnNum}='GetErrorCodeMessage'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='cstring'; fcns.RHS{fcnNum}={'voidPtr', 'int32'};fcnNum=fcnNum+1;
% char ** __stdcall GetDeviceList ( HANDLE Handle , int * NrOfFrontEnds ); 
fcns.thunkname{fcnNum}='voidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='GetDeviceList'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='stringPtrPtr'; fcns.RHS{fcnNum}={'voidPtr', 'int32Ptr'};fcnNum=fcnNum+1;
% void __stdcall FreeDeviceList ( HANDLE Handle , int NrOfFrontEnds , char ** DeviceList ); 
fcns.thunkname{fcnNum}='voidvoidPtrint32voidPtrThunk';fcns.name{fcnNum}='FreeDeviceList'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}=[]; fcns.RHS{fcnNum}={'voidPtr', 'int32', 'stringPtrPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetConnectionProperties ( HANDLE Handle , int * SignalStrength , unsigned int * NrOfCRCErrors , unsigned int * NrOfSampleBlocks ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='GetConnectionProperties'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'int32Ptr', 'uint32Ptr', 'uint32Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall StartCardFile ( void * Handle ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='StartCardFile'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall StopCardFile ( void * Handle ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='StopCardFile'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall CloseCardFile ( void * Handle ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='CloseCardFile'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% LONG __stdcall GetCardFileSamples ( HANDLE Handle , PULONG SampleBuffer , ULONG SampleBufferSizeInBytes ); 
fcns.thunkname{fcnNum}='longvoidPtrvoidPtrulongThunk';fcns.name{fcnNum}='GetCardFileSamples'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}={'voidPtr', 'ulongPtr', 'ulong'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetRefCalculation ( HANDLE Handle , int OnOrOff ); 
fcns.thunkname{fcnNum}='uint8voidPtrint32Thunk';fcns.name{fcnNum}='SetRefCalculation'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'int32'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetMeasuringMode ( HANDLE Handle , ULONG Mode , int Value ); 
fcns.thunkname{fcnNum}='uint8voidPtrulongint32Thunk';fcns.name{fcnNum}='SetMeasuringMode'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'ulong', 'int32'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetExtFrontEndInfo ( HANDLE Handle , TMSiExtFrontendInfoType * ExtFrontEndInfo , TMSiBatReportType * BatteryReport , TMSiStorageReportType * StorageReport , TMSiDeviceReportType * DeviceReport ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrvoidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='GetExtFrontEndInfo'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'TMSiExtFrontendInfoPtr', 'TMSiBatReportPtr', 'TMSiStorageReportPtr', 'TMSiDeviceReportPtr'};fcnNum=fcnNum+1;
% const char * __stdcall GetRevision ( HANDLE Handle ); 
fcns.thunkname{fcnNum}='cstringvoidPtrThunk';fcns.name{fcnNum}='GetRevision'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='cstring'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall ConvertSignalFormat ( HANDLE Handle , SIGNAL_FORMAT * psf , unsigned int Index , int * Size , int * Format , int * Type , int * SubType , float * UnitGain , float * UnitOffSet , int * UnitId , int * UnitExponent , char Name [ 40 ] ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtruint32voidPtrvoidPtrvoidPtrvoidPtrvoidPtrvoidPtrvoidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='ConvertSignalFormat'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 's_SIGNAL_FORMATPtr', 'uint32', 'int32Ptr', 'int32Ptr', 'int32Ptr', 'int32Ptr', 'singlePtr', 'singlePtr', 'int32Ptr', 'int32Ptr', 'int8Ptr'};fcnNum=fcnNum+1;
% int __stdcall TMSIRawData ( HANDLE Handle , int KeyCode , unsigned short NrOfShortsIn , const short * const InBuffer , unsigned short ExpectedBlockType , unsigned short * NrOfShortsOut , short * OutBuffer ); 
fcns.thunkname{fcnNum}='int32voidPtrint32uint16voidPtruint16voidPtrvoidPtrThunk';fcns.name{fcnNum}='TMSIRawData'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='int32'; fcns.RHS{fcnNum}={'voidPtr', 'int32', 'uint16', 'int16Ptr', 'uint16', 'uint16Ptr', 'int16Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetRandomKey ( void * Handle , char * Key , unsigned int * LengthKeyInBytes ); 
fcns.thunkname{fcnNum}='uint8voidPtrcstringvoidPtrThunk';fcns.name{fcnNum}='GetRandomKey'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'cstring', 'uint32Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall UnlockFrontEnd ( void * Handle , char * Key , unsigned int * LengthKeyInBytes ); 
fcns.thunkname{fcnNum}='uint8voidPtrcstringvoidPtrThunk';fcns.name{fcnNum}='UnlockFrontEnd'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'cstring', 'uint32Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetOEMSize ( void * Handle , unsigned int * LengthInBytes ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrThunk';fcns.name{fcnNum}='GetOEMSize'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'uint32Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetOEMData ( HANDLE Handle , const char * BinaryOEMData , const unsigned int OEMDataLengthInBytes ); 
fcns.thunkname{fcnNum}='uint8voidPtrcstringuint32Thunk';fcns.name{fcnNum}='SetOEMData'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'cstring', 'uint32'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetOEMData ( HANDLE Handle , char * BinaryOEMData , unsigned int * OEMDataLengthInBytes ); 
fcns.thunkname{fcnNum}='uint8voidPtrcstringvoidPtrThunk';fcns.name{fcnNum}='GetOEMData'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'cstring', 'uint32Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall OpenFirstDevice ( HANDLE Handle ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='OpenFirstDevice'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetStorageMode ( HANDLE Handle , int OnOrOff ); 
fcns.thunkname{fcnNum}='uint8voidPtrint32Thunk';fcns.name{fcnNum}='SetStorageMode'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'int32'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetDigSensorData ( void * Handle , unsigned int * DataSize , unsigned char * SensorData ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='GetDigSensorData'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'uint32Ptr', 'uint8Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetDigSensorData ( void * Handle , unsigned int GivenDataSizeInBytes , unsigned char * GivenSensorData ); 
fcns.thunkname{fcnNum}='uint8voidPtruint32voidPtrThunk';fcns.name{fcnNum}='SetDigSensorData'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'uint32', 'uint8Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall GetFlashStatus ( HANDLE Handle , long * Status ); 
fcns.thunkname{fcnNum}='uint8voidPtrvoidPtrThunk';fcns.name{fcnNum}='GetFlashStatus'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'longPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall StartFlashData ( void * Handle , unsigned int StartAdress , unsigned int Length ); 
fcns.thunkname{fcnNum}='uint8voidPtruint32uint32Thunk';fcns.name{fcnNum}='StartFlashData'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'uint32', 'uint32'};fcnNum=fcnNum+1;
% LONG __stdcall GetFlashSamples ( HANDLE Handle , PULONG SampleBuffer , ULONG SampleBufferSizeInBytes ); 
fcns.thunkname{fcnNum}='longvoidPtrvoidPtrulongThunk';fcns.name{fcnNum}='GetFlashSamples'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='long'; fcns.RHS{fcnNum}={'voidPtr', 'ulongPtr', 'ulong'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall StopFlashData ( void * Handle ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='StopFlashData'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall FlashEraseMemory ( HANDLE Handle ); 
fcns.thunkname{fcnNum}='uint8voidPtrThunk';fcns.name{fcnNum}='FlashEraseMemory'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetFlashData ( HANDLE Handle , unsigned int StartAdressInBytes , PULONG FlashData , int FlashBlockLengthInWords ); 
fcns.thunkname{fcnNum}='uint8voidPtruint32voidPtrint32Thunk';fcns.name{fcnNum}='SetFlashData'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'uint32', 'ulongPtr', 'int32'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall SetChannelReferenceSwitch ( void * Handle , unsigned int GivenDataSizeInBytes , unsigned char * GivenChannelSwitchData ); 
fcns.thunkname{fcnNum}='uint8voidPtruint32voidPtrThunk';fcns.name{fcnNum}='SetChannelReferenceSwitch'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'uint32', 'uint8Ptr'};fcnNum=fcnNum+1;
% BOOLEAN __stdcall TMSIGetRawIdData ( HANDLE Handle , int KeyCode , unsigned short * NrOfShortsOut , short * OutBuffer ); 
fcns.thunkname{fcnNum}='uint8voidPtrint32voidPtrvoidPtrThunk';fcns.name{fcnNum}='TMSIGetRawIdData'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}='uint8'; fcns.RHS{fcnNum}={'voidPtr', 'int32', 'uint16Ptr', 'int16Ptr'};fcnNum=fcnNum+1;
structs.s_SYSTEMTIME.members=struct('wYear', 'uint16', 'wMonth', 'uint16', 'wDayOfWeek', 'uint16', 'wDay', 'uint16', 'wHour', 'uint16', 'wMinute', 'uint16', 'wSecond', 'uint16', 'wMilliseconds', 'uint16');
structs.s_SIGNAL_FORMAT.members=struct('Size', 'ulong', 'Elements', 'ulong', 'Type', 'ulong', 'SubType', 'ulong', 'Format', 'ulong', 'Bytes', 'ulong', 'UnitGain', 'single', 'UnitOffSet', 'single', 'UnitId', 'ulong', 'UnitExponent', 'long', 'Name', 'uint16#40', 'Port', 'ulong', 'PortName', 'uint16#40', 'SerialNumber', 'ulong');
structs.s_FRONTENDINFO.members=struct('NrOfChannels', 'uint16', 'SampleRateSetting', 'uint16', 'Mode', 'uint16', 'maxRS232', 'uint16', 'Serial', 'ulong', 'NrExg', 'uint16', 'NrAux', 'uint16', 'HwVersion', 'uint16', 'SwVersion', 'uint16', 'RecBufSize', 'uint16', 'SendBufSize', 'uint16', 'NrOfSwChannels', 'uint16', 'BaseSf', 'uint16', 'Power', 'uint16', 'Check', 'uint16');
structs.s_FeatureData.members=struct('Id', 'ulong', 'Info', 'ulong');
structs.TMSiFileInfo.members=struct('FileID', 'uint16', 'StartRecTime', 's_SYSTEMTIME', 'StopRecTime', 's_SYSTEMTIME');
structs.TMSiTDFHeader.members=struct('NumberOfSamp', 'uint32', 'StartRecTime', 's_SYSTEMTIME', 'EndRecTime', 's_SYSTEMTIME', 'FrontEndSN', 'uint32', 'FrontEndAdpSN', 'uint32', 'FrontEndHWVer', 'uint16', 'FrontEndSWVer', 'uint16', 'FrontEndAdpHWVer', 'uint16', 'FrontEndAdpSWVer', 'uint16', 'RecordingSampleRate', 'uint16', 'PatientID', 'int8#128', 'UserString1', 'int8#64');
structs.TMSiRecordingConfig.members=struct('StorageType', 'uint16', 'RecordingSampleRate', 'uint16', 'NumberOfChan', 'uint16', 'StartControl', 'uint32', 'EndControl', 'uint32', 'CardStatus', 'uint32', 'MeasureFileName', 'int8#32', 'AlarmTimeStart', 's_SYSTEMTIME', 'AlarmTimeStop', 's_SYSTEMTIME', 'AlarmTimeInterval', 's_SYSTEMTIME', 'AlarmTimeCount', 'uint32', 'FrontEndSN', 'uint32', 'FrontEndAdpSN', 'uint32', 'RecordCondition', 'uint32', 'RFInterfStartTime', 's_SYSTEMTIME', 'RFInterfStopTime', 's_SYSTEMTIME', 'RFInterfInterval', 's_SYSTEMTIME', 'RFInterfCount', 'uint32', 'PatientID', 'int8#128', 'UserString1', 'int8#64');
structs.TMSiBatReport.members=struct('Temp', 'int16', 'Voltage', 'int16', 'Current', 'int16', 'AccumCurrent', 'int16', 'AvailableCapacityInPercent', 'int16', 'DoNotUse1', 'uint16', 'DoNotUse2', 'uint16', 'DoNotUse3', 'uint16', 'DoNotUse4', 'uint16');
structs.TMSiStorageReport.members=struct('StructSize', 'uint32', 'TotalSize', 'uint32', 'UsedSpace', 'uint32', 'SDCardCID', 'uint32#4', 'DoNotUse1', 'uint16', 'DoNotUse2', 'uint16', 'DoNotUse3', 'uint16', 'DoNotUse4', 'uint16');
structs.TMSiDeviceReport.members=struct('AdapterSN', 'uint32', 'AdapterStatus', 'uint32', 'AdapterCycles', 'uint32', 'MobitaSN', 'uint32', 'MobitaStatus', 'uint32', 'MobitaCycles', 'uint32', 'DoNotUse1', 'uint16', 'DoNotUse2', 'uint16', 'DoNotUse3', 'uint16', 'DoNotUse4', 'uint16');
structs.TMSiExtFrontendInfo.members=struct('CurrentSamplerate', 'uint16', 'CurrentInterface', 'uint16', 'CurrentBlockType', 'uint16', 'DoNotUse1', 'uint16', 'DoNotUse2', 'uint16', 'DoNotUse3', 'uint16', 'DoNotUse4', 'uint16');
enuminfo.e_TmsiErrorCodeEnum=struct('TMSiErrorCodeUnsuccessfull',256,'TMSiErrorCodeInvalidHandle',257,'TMSiErrorCodeNotImplemented',258);
enuminfo.e_TMSiStartControl=struct('sc_man_shutdown_enable',256,'sc_rf_recurring',128,'sc_rf_timed_start',64,'sc_rf_auto_start',32,'sc_alarm_recurring',16,'sc_power_on_record_auto_start',8,'sc_man_record_enable',4,'sc_alarm_record_auto_start',2,'sc_rtc_set',1);
enuminfo.e_TMSiConnectionEnum=struct('TMSiConnectionUndefined',0,'TMSiConnectionFiber',1,'TMSiConnectionBluetooth',2,'TMSiConnectionUSB',3,'TMSiConnectionWifi',4,'TMSiConnectionNetwork',5);
methodinfo=fcns;