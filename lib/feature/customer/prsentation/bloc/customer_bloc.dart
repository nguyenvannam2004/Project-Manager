import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_manager/feature/customer/domain/usecase/createcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/deletecustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/getcustomer_usecase.dart';
import 'package:project_manager/feature/customer/domain/usecase/updatecustomerusecase.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_event.dart';
import 'package:project_manager/feature/customer/prsentation/bloc/customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomerUsecase getCustomerUsecase;
  final CreatecustomerUsecase createCustomerUsecase;
  final DeleteCustomerUsecase deleteCustomerUsecase;
  final UpdateCustomerUsecase updateCustomerUsecase;

  CustomerBloc({
    required this.getCustomerUsecase,
    required this.createCustomerUsecase,
    required this.deleteCustomerUsecase,
    required this.updateCustomerUsecase,
  }) : super(CustomerInitialState()) {
    on<LoadCustomersEvent>(_onLoadCustomers);
    on<CreateCustomerEvent>(_onCreateCustomer);
    on<UpdateCustomerEvent>(_onUpdateCustomer);
    on<DeleteCustomerEvent>(_onDeleteCustomer);
  }

  Future<void> _onLoadCustomers(
    LoadCustomersEvent event,
    Emitter<CustomerState> emit,
  ) async {
    print('LoadCustomersEvent received');
    emit(CustomerLoadingState());
    try {
      print('Calling getCustomerUsecase');
      final customers = await getCustomerUsecase.call();
      print('Received customers: $customers');
      emit(CustomerLoadedState(List.from(customers))); // Tạo bản sao
    } catch (e, stack) {
      print('Error loading customers: $e');
      print('Stack trace: $stack');
      emit(CustomerErrorState('Không thể tải danh sách khách hàng: $e'));
    }
  }

  Future<void> _onCreateCustomer(
    CreateCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoadingState());
    try {
      await createCustomerUsecase.call(
        event.id,
        event.name,
        event.phone,
        event.email,
      );
      final customers = await getCustomerUsecase.call();
      emit(CustomerLoadedState(List.from(customers))); // Tạo bản sao
    } catch (e, stackTrace) {
      emit(CustomerErrorState('Không thể tạo khách hàng: $e'));
    }
  }

  Future<void> _onUpdateCustomer(
    UpdateCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoadingState());
    try {
      // usecase expects (id, name, phone, email)
      await updateCustomerUsecase.call(
        event.id,
        event.name,
        event.phone,
        event.email,
      );
      final customers = await getCustomerUsecase.call();
      emit(CustomerLoadedState(List.from(customers))); // Tạo bản sao
    } catch (e, stackTrace) {
      emit(CustomerErrorState('Không thể cập nhật khách hàng: $e'));
    }
  }

  Future<void> _onDeleteCustomer(
    DeleteCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(CustomerLoadingState());
    try {
      await deleteCustomerUsecase.call(event.id);
      final customers = await getCustomerUsecase.call();
      emit(CustomerLoadedState(List.from(customers)));
    } catch (e, stackTrace) {
      emit(CustomerErrorState('Không thể xóa khách hàng: $e'));
    }
  }
}
