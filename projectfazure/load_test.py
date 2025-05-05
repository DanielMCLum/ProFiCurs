import time
import sys
import multiprocessing
import requests

def generate_http_load(interval=int(sys.argv[1]), utilization=int(sys.argv[2]), url=sys.argv[3]):
    "Generate HTTP requests for a duration of interval seconds with a given utilization"
    start_time = time.time()
    for i in range(0, int(interval)):
        print(f"About to send request {i}")
        try:
            response = requests.get(url)
            print(f"Response status code: {response.status_code}")
        except Exception as e:
            print(f"Error sending request: {e}")
        
        # Sleep to simulate the desired utilization
        elapsed_time = time.time() - start_time
        sleep_time = max(0, (1 - utilization / 100.0) - elapsed_time)
        time.sleep(sleep_time)
        start_time += 1

if __name__ == '__main__':
    if len(sys.argv) > 3:
        print("No of CPUs:", multiprocessing.cpu_count())
        processes = []
        for _ in range(multiprocessing.cpu_count()):
            p = multiprocessing.Process(target=generate_http_load, args=(int(sys.argv[1]), int(sys.argv[2]), sys.argv[3]))
            p.start()
            processes.append(p)
        for process in processes:
            process.join()
    else:
        print("Usage:\n python %s interval utilization url" % __file__)