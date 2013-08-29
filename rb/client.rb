# include thrift-generated code
$:.push('../gen-rb')

require 'thrift'
require 'calculator'

begin
	port = ARGV[0] || 9090

	# 摘抄: http://dongxicheng.org/search-engine/thrift-framework-intro/ 
	# 定义数据传输方式
	#   TSocket -阻塞式socker
        #   TFramedTransport – 以frame为单位进行传输，非阻塞式服务中使用
        #   TFileTransport – 以文件形式进行传输
        #   TMemoryTransport – 将内存用于I/O. java实现时内部实际使用了简单的ByteArrayOutputStream
        #   TZlibTransport – 使用zlib进行压缩， 与其他传输方式联合使用。当前无java实现
	#
        # 定义TTransport，为你的client设置传输方式（如socket， http等）
	socket = Thrift::Socket.new('localhost', 9090)
	transport = Thrift::BufferedTransport.new(socket)

	# 摘抄: http://dongxicheng.org/search-engine/thrift-framework-intro/ 
	# 定义数据传输格式
	#   TBinaryProtocol – 二进制格式.
        #   TCompactProtocol – 压缩格式
        #   TJSONProtocol – JSON格式
        #   TSimpleJSONProtocol –提供JSON只写协议, 生成的文件很容易通过脚本语言解析
        #   TDebugProtocol – 使用易懂的可读的文本格式，以便于debug
	#
        # 定义Protocal，使用装饰模式（Decorator设计模式）封装TTransport，为你的数据设置编码格式（如二进制格式，JSON格式等）
	protocol = Thrift::BinaryProtocol.new(transport)
	# 实例化client对象，调用服务接口
	client = Calculator::Client.new(protocol)

	transport.open()

	ar = ArithmeticOperation.new()    
	ar.op = BinaryOperation::ADDITION
	ar.lh_term = 99
	ar.rh_term = 3
	
	# Run a remote calculation
	result = client.calc(ar)  #it accessing the ruby server program method calc via thrift service
	puts result.inspect
	
	#Run a Async call
	client.run_task()
	
	transport.close()
rescue
	puts $!
end
