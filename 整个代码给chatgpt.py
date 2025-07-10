import os

def _write_file_to_output(file_path, output_handle):
    """
    Helper function to write a single file's content to the output handle.
    一个辅助函数，用于将单个文件的内容写入到输出文件。
    """
    # Get the file name from the full path
    # 从完整路径中获取文件名
    file_name = os.path.basename(file_path)

    # Skip hidden files like .DS_Store
    # 跳过隐藏文件，例如 .DS_Store
    if file_name.startswith('.'):
        return

    try:
        # Open and read the source file
        # 打开并读取源文件
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
            # Write a clear header with the full file path for better context
            # 写入一个清晰的标题，包含完整文件路径，以便更好地了解上下文
            output_handle.write(f"--- File: {file_path} ---\n")
            
            # Extract the file extension for markdown code block
            # 提取文件扩展名用于 markdown 代码块
            file_extension = os.path.splitext(file_name)[1].lstrip('.')
            
            # Write the content inside a markdown code block
            # 将内容写入 markdown 代码块中
            output_handle.write(f"```{file_extension}\n")
            output_handle.write(file.read())
            output_handle.write('\n```\n\n')
    except Exception as e:
        # Print an error message if a file cannot be processed
        # 如果文件无法处理，则打印错误信息
        print(f"Error processing file: {file_path} - {e}")

def consolidate_files(input_paths, output_file):
    """
    Consolidates content from a list of files and/or directories into a single output file.
    将来自文件和/或目录列表的内容合并到单个输出文件中。

    :param input_paths: A list of file and/or directory paths. (一个包含文件和/或目录路径的列表)
    :param output_file: The path for the consolidated output file. (合并后输出文件的路径)
    """
    # Open the output file in write mode
    # 以写入模式打开输出文件
    with open(output_file, 'w', encoding='utf-8') as output:
        # Iterate over each path provided in the input list
        # 遍历输入列表中的每个路径
        for path in input_paths:
            # Check if the path exists
            # 检查路径是否存在
            if not os.path.exists(path):
                print(f"Warning: Path does not exist and will be skipped: {path}")
                continue

            # If the path is a directory, walk through its contents
            # 如果路径是一个目录，则遍历其内容
            if os.path.isdir(path):
                # os.walk traverses the directory tree top-down or bottom-up
                # os.walk 会自顶向下或自底向上遍历目录树
                for root, dirs, files in os.walk(path):
                    # Optional: Sort files for consistent order
                    # 可选：对文件进行排序以保证顺序一致
                    files.sort()
                    for file_name in files:
                        file_path = os.path.join(root, file_name)
                        _write_file_to_output(file_path, output)
            
            # If the path is a single file, process it directly
            # 如果路径是单个文件，则直接处理
            elif os.path.isfile(path):
                _write_file_to_output(path, output)
            
            else:
                print(f"Warning: Path is not a file or directory and will be skipped: {path}")

# --- Usage Example (使用示例) ---

# Create a list of all the paths you want to include.
# You can mix directories and individual files.
# 创建一个包含所有您想包括的路径的列表。
# 您可以混合使用目录和单个文件。
paths_to_consolidate = [
    '/Users/admin/Desktop/Flutter_app/20250613-lochvanese/lochvanese/lib',  # An entire directory (一个完整的目录)
    '/Users/admin/Desktop/Flutter_app/20250613-lochvanese/lochvanese/index.html',
     '/Users/admin/Desktop/Flutter_app/20250613-lochvanese/lochvanese/README.md' # A single file (一个单独的文件)
]

# Define the output file path
# 定义输出文件的路径
output_file_path = '/Users/admin/Desktop/Flutter_app/20250613-lochvanese/lochvanese/gemini.txt'

# Call the function with the list of paths
# 使用路径列表调用函数
consolidate_files(paths_to_consolidate, output_file_path)

print(f"Consolidation complete. Output saved to {output_file_path}")
