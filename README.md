# How-to-maintain-selected-rows-while-changing-the-page-in-the-Flutter-DataPager-SfDataGrid-

The Syncfusion [Flutter DataTable](https://help.syncfusion.com/flutter/datagrid/overview) supports maintaining the selected rows collection within a page. While navigating to another page, the previously selected rows are not maintained. 

You can maintain the internal collection to hold the selected data with the page index in the [onPageNavigationStart](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataPager/onPageNavigationStart.html) callback. Then, you should add those selected rows of the navigated page to the [DataGridController.selectedRows](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridController/selectedRows.html) property in the [onPageNavigationEnd](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataPager/onPageNavigationEnd.html) callback so that you can maintain the selection even after navigation. 

The following steps explain how to maintain selected rows while changing the page in the Flutter DataPager:

## STEP 1: 
Create a data source class by extending [DataGridSource](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource-class.html) for mapping data to the SfDataGrid.

```dart
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
```
## STEP 2:

Create a new [SfDataPager](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataPager/SfDataPager.html) widget, and set the [SfDataGrid.DataGridSource](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource-class.html) to the [SfDataPager.Delegate](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataPager/delegate.html) property.

Set the number of pages required to display in the DataPager to the [pageCount](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataPager/pageCount.html) property. Maintain the selected rows in the internal collection `selectedRowsCollection`. In the `onPageNavigationStart` callback, add the desired rows based on the current page, and in the `onPageNavigationEnd` callback, assign the selected rows for the current page from a collection.

```dart
  Map<String, List<DataGridRow>> selectedRowsCollection = {};

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
```

## STEP 3: 
Initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with all the required properties. [SfDataPager](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataPager/SfDataPager.html) can placed above or below based on the requirement of managing the easy data paging.

Wrap the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) and [SfDataPager](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataPager/SfDataPager.html) inside the [SizedBox](https://api.flutter.dev/flutter/widgets/SizedBox-class.html).

Here we are placed the `SfDataPager` below of the `SfDataGrid` inside a [Column](https://api.flutter.dev/flutter/widgets/Column-class.html) widget.

```dart
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
```