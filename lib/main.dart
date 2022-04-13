import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(const MaterialApp(home: SfDataGridDemo()));
}

class SfDataGridDemo extends StatefulWidget {
  const SfDataGridDemo({Key? key}) : super(key: key);

  @override
  _SfDataGridDemoState createState() => _SfDataGridDemoState();
}

class _SfDataGridDemoState extends State<SfDataGridDemo> {
  late EmployeeDataSource _employeeDataSource;
  List<Employee> _employees = <Employee>[];
  final double _dataPagerHeight = 70.0;
  final DataGridController _dataGridController = DataGridController();
  final DataPagerController _dataPagerController = DataPagerController();

  final int _rowsPerPage = 5;
  Map<String, List<DataGridRow>> selectedRowsCollection = {};

  @override
  void initState() {
    super.initState();
    _employees = getEmployeeData();
    _employeeDataSource = EmployeeDataSource(_employees);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Syncfusion DataPager')),
        body: LayoutBuilder(builder: (context, constraints) {
          return Column(children: [
            SizedBox(
                height: constraints.maxHeight - _dataPagerHeight,
                child: SfDataGrid(
                    source: _employeeDataSource,
                    controller: _dataGridController,
                    selectionMode: SelectionMode.multiple,
                    navigationMode: GridNavigationMode.row,
                    columnWidthMode: ColumnWidthMode.fill,
                    columns: <GridColumn>[
                      GridColumn(
                          columnName: 'id',
                          label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              alignment: Alignment.center,
                              child: const Text('ID',
                                  overflow: TextOverflow.ellipsis))),
                      GridColumn(
                          columnName: 'name',
                          label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              alignment: Alignment.center,
                              child: const Text('Name',
                                  overflow: TextOverflow.ellipsis))),
                      GridColumn(
                          columnName: 'designation',
                          label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              alignment: Alignment.center,
                              child: const Text('Designation',
                                  overflow: TextOverflow.ellipsis))),
                      GridColumn(
                          columnName: 'salary',
                          label: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              alignment: Alignment.center,
                              child: const Text('Salary',
                                  overflow: TextOverflow.ellipsis))),
                    ])),
            SizedBox(height: 60, child: _buildDataPager())
          ]);
        }));
  }

  Widget _buildDataPager() {
    return SfDataPager(
        pageCount: ((_employees.length / _rowsPerPage).ceil()).toDouble(),
        direction: Axis.horizontal,
        delegate: _employeeDataSource,
        controller: _dataPagerController,
        onPageNavigationStart: (int pageIndex) {
          selectedRowsCollection[_dataPagerController.selectedPageIndex
              .toString()] = _dataGridController.selectedRows.toList();
        },
        onPageNavigationEnd: (int pageIndex) {
          if (selectedRowsCollection.containsKey('$pageIndex') &&
              selectedRowsCollection['$pageIndex'] != null &&
              selectedRowsCollection['$pageIndex']!.isNotEmpty) {
            _dataGridController.selectedRows =
                selectedRowsCollection['$pageIndex']!;
          }
        });
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(10001, 'James', 'Project Lead', 79000),
      Employee(10002, 'Kathryn', 'Manager', 90000),
      Employee(10003, 'Lara', 'Developer', 20000),
      Employee(10004, 'Michael', 'Designer', 25000),
      Employee(10005, 'Martin', 'Developer', 35000),
      Employee(10006, 'Newberry', 'Developer', 30000),
      Employee(10007, 'Balnc', 'UI Designer', 25000),
      Employee(10008, 'Perry', 'Project Lead', 75000),
      Employee(10009, 'Gable', 'Developer', 33000),
      Employee(10010, 'Grimes', 'Testing Engineer', 35000),
      Employee(10011, 'Jefferson', 'Developer', 27000),
      Employee(10012, 'Spencer', 'Project Lead', 25000),
      Employee(10013, 'Vargas', 'Developer', 32000),
      Employee(10014, 'Michael', 'UI Designer', 29000),
      Employee(10015, 'Stark', 'Developer', 15000),
      Employee(10016, 'Edwards', 'Manager', 89000),
      Employee(10017, 'Balnc', 'Testing Engineer', 23000),
      Employee(10018, 'Chief', 'Project Lead', 69000),
      Employee(10019, 'Gable', 'UI Designer', 30000),
      Employee(10020, 'Fitz', 'Developer', 37000),
    ];
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(List<Employee> employees) {
    buildDataGridRow(employees);
  }

  void buildDataGridRow(List<Employee> employeeData) {
    dataGridRow = employeeData.map<DataGridRow>((employee) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: employee.id),
        DataGridCell<String>(columnName: 'name', value: employee.name),
        DataGridCell<String>(
            columnName: 'designation', value: employee.designation),
        DataGridCell<int>(columnName: 'salary', value: employee.salary),
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRow = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => dataGridRow.isEmpty ? [] : dataGridRow;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);
  final int id;
  final String name;
  final String designation;
  final int salary;
}
