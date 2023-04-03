import numpy as np
from functools import reduce
import math
import copy


class Event():
    def __init__(self, ev, time, J1, J2, St, S, n, Q):
        self.ev = ev
        self.time = time
        self.J1 = J1
        self.J2 = J2
        self.St = St
        self.S = S
        self.q_len = n
        self.Q = Q

    def as_dict(self):
        return {'Event': self.ev, 'System time': self.time, 'J1 arrival': self.J1, 'J2 arrival': self.J2, 'Server job completion time': self.St, 'Server status': self.S, 'Queue': self.Q, 'Queue length': self.q_len}


def getRand_Exp(l):
    rand = np.random.uniform(low=0.0, high=1.0, size=None) #base generator
    num = (-4/l)*math.log((1-rand))  #natural log
    return round(num,2)

def getRand_Norm(m, b):
    sum = 0
    for n in range (1,500):
        rand = np.random.uniform(low=0.0, high=1.0, size=None) #base generator
        sum+= (rand - n/2)
    z = math.sqrt((500/12))
    return z*b+m


    # For all following events:
    # Choosing next event as min(J1_Arrival, J2_Arrival, Server_Job_Completion)
    # If J1_Arrival :
    # Time=J1, J1=newJ1, J2=same, St=Same, 
    # S=0 if time>previous S and 0 otherwise
    # queue = queue+J1 if St>Time and previous S = 1
    # n = len(queue)

    # If Server_Job_Completion
    # Time = St of previous
    #   if empty queue:
    #       ev="Stop of service", S=0, n=0, q=[]
    #   if not empty queue:
    #       get last enetered from queue
    #       if J1:
    #           ev="J1", S=1, St=time+P1, n-1, q-1
def eventLoop():
    end_time = 30 #in minutes
    sys_time = 0
    #events = []

    I1 = getRand_Exp(1.5)
    I2 = getRand_Exp(4)

    events = [(Event('Start', 0, I1, I2, end_time+1, 0, 0, []))]

    while (sys_time<end_time):
        I1 = getRand_Exp(1.5)
        I2 = getRand_Exp(4)
        P1 = getRand_Norm(2,0.3)
        P2 = getRand_Norm(2.5,0.5)

        new_event = copy.deepcopy(events[-1])

        # Choosing next event as min(J1_Arrival, J2_Arrival, Server_Job_Completion)
        print("* Choosing from: J1=" + str(events[-1].J1) + ", J2="+ str(events[-1].J2) +", St="+ str(events[-1].St))
        next_ev_time = min(events[-1].J1, events[-1].J2, events[-1].St)
        print("next_ev_time: ", next_ev_time)
        new_event.time = round(next_ev_time,2)

        if(next_ev_time == events[-1].J1):
            print("J1 is min")
            new_event.ev = "J1"
            new_event.J1 = new_event.time+I1
            if(events[-1].S==0): 
                new_event.S = 1
                new_event.St = next_ev_time+P1
            else:
                new_event.Q.append("J1")
                new_event.n = len(new_event.Q)
        
        elif(next_ev_time == events[-1].J2):
            print("J2 is min")
            new_event.ev = "J2"
            new_event.J2 = new_event.time+I2
            if(events[-1].S==0): 
                new_event.S = 1
                new_event.St = next_ev_time+P2
            else:
                new_event.Q.append("J2")
                new_event.n = len(new_event.Q)

        elif(next_ev_time == events[-1].St):
            print("Job completion is min")
            if(len(events[-1].Q)==0):
                new_event.ev="Stop of service"
                new_event.S=0
                new_event.n=0
                new_event.Q=[]
            else:
                if(events[-1].Q[-1] =="J1"):
                    new_event.ev="J1"
                    new_event.St=new_event.time+P1
                elif(events[-1].Q[-1] =="J2"):
                    new_event.ev="J2"
                    new_event.St=new_event.time+P2                   
                new_event.S=1
                new_event.n-=1
                new_event.Q.pop()

        events.append(new_event)
        sys_time=events[-1].time   
        print("*** System time is currently: ",sys_time)

    return events       

def main():

    import pandas as pd
    events = eventLoop()
    df = pd.DataFrame([x.as_dict() for x in events])
    print(df)
    import os  

    os.makedirs('CSV', exist_ok=True)  
    df.to_csv('CSV/out.csv')  

main()