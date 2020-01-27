from locust import HttpLocust, TaskSet, task, between

class CheckBehavior(TaskSet):
    @task(1)
    def getPimock(self):
        headers = getHeaderPimock()
        self.client.get(
            url = "/healthz",
            headers = headers,
            name = "Check Pimock"
        )

class MetricsLocust(HttpLocust):
    task_set = CheckBehavior
    wait_time = between(0.500, 1)

def getHeaderPimock():
    return {
    "Host" : "example.com"
    }
