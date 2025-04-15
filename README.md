# ⚡ Performance Benchmark between JSON and FlatBuffers

This project performs benchmarks to compare the performance of **JSON** and **FlatBuffers** in terms of **writing** ✍️ and **reading** 📖 large amounts of data. The comparison focuses particularly on two operations: the time required to write and read data from files ⏱️, and the size of the generated files 💾.

## 🎯 Objective

The main goal of this code is to evaluate how **JSON** and **FlatBuffers** perform when handling large volumes of data 📊, simulating a scenario where a significant number of people 👥 are stored in a data structure. Each person contains a name and an age.

The comparison is based on the following criteria:

- ⌛ **Write Time**: How long each format takes to write a large number of records to a file.
- 🕒 **Read Time**: How long it takes to read the files and process the data.
- 📁 **File Size**: The size of the generated file in each format.

## 🧱 Code Structure

The code performs the following tests:

1. **📝 JSON**:
   - Creates a list of people with attributes `name` and `age`.
   - Serializes the list to JSON and writes it to a file (`output_json.json`).
   - Reads the JSON file and decodes the data.

2. **📦 FlatBuffers**:
   - Creates a list of `Person` objects and serializes them using the **FlatBuffers** library.
   - Writes the data in binary format (`output_flatbuffers.bin`).
   - Reads the binary file and processes the information.

## ▶️ How to Use

### 1. 🧰 Install Dependencies

Make sure you have **Dart** installed on your system. To install Dart, follow the [official documentation](https://dart.dev/get-dart).

### 2. 📦 Install Packages

Before running the code, you need to install the project dependencies. In your terminal, navigate to the project folder and run:

```bash
dart pub get
```

### 3. 🚀 Run the Benchmarks

Execute the code to start the benchmark. The script will perform the read and write tests for both formats and print the average execution time for each operation:

```bash
dart run read_write.dart
```

### 4. 📋 Expected Output

The terminal will display the following results:

- ⏱️ **Average Write Time**: Time taken to write files (JSON and FlatBuffers).
- 📖 **Average Read Time**: Time taken to read and process data from the files.
- 💾 **File Size**: The size of the files generated (`output_json.json` and `output_flatbuffers.bin`) in bytes, KB, and MB.

## 📈 Example Output

```bash
📦 Write Benchmark
✅ JSON: Average write (1000000 people): 928.2ms
✅ FlatBuffers: Average write (1000000 people): 475.1ms

📥 Read Benchmark
✅ JSON: Average read: 695.3ms
✅ FlatBuffers: Average read: 19.7ms

📊 Generated File Sizes
📁 JSON: 36088903 bytes (35243.07 KB | 34.42 MB)
📁 FlatBuffers: 43960024 bytes (42929.71 KB | 41.92 MB)
```

## ✅ Conclusion

This benchmark allows for a direct performance comparison between **JSON** and **FlatBuffers** when working with large datasets. While **FlatBuffers** tends to be faster at reading and more compact in size, **JSON** is easier to work with and might be preferable for human-readable or simple-use scenarios.

## 📄 License

This project is open source and available under the [MIT License](LICENSE).