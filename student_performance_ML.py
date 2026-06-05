
>>> import random
... import string
... import pandas as pd
... from datetime import datetime
... 
...
... # CONFIG
... NUM_STUDENTS = 5000
... ID_LEN = 8
... OUTPUT_DIR = r"C:\PythonCodes\studentDataCreator"
... 
... random.seed(42)
... 
... # =========================
... # UTILITIES
... # =========================
... def generate_id(existing_ids, length):
...     while True:
...         sid = ''.join(random.choices(string.ascii_uppercase + string.digits, k=length))
...         if sid not in existing_ids:
...             existing_ids.add(sid)
...             return sid
... 
... def weighted_choice(choices):
...     values, weights = zip(*choices)
...     return random.choices(values, weights=weights, k=1)[0]
... 
... # =========================
... # FEATURE GENERATORS
... # =========================
... def generate_gender():
...     return weighted_choice([
...         ("M", 0.49),
...         ("F", 0.49),
...         ("O", 0.02)
    ])

def generate_school_type():
    return weighted_choice([
        ("Public", 0.7),
        ("Private", 0.25),
        ("Other", 0.05)
    ])

def generate_parental_involvement():
    return weighted_choice([
        ("High", 0.35),
        ("Medium", 0.45),
        ("Low", 0.20)
    ])

def generate_peer_influence():
    return weighted_choice([
        ("Positive", 0.4),
        ("Neutral", 0.35),
        ("Negative", 0.25)
    ])

def generate_learning_disability():
    return "Y" if random.random() < 0.12 else "N"

def generate_attendance(ld_flag):
    base = random.uniform(75, 98)
    if ld_flag == "Y":
        base -= random.uniform(5, 15)
    return round(max(base, 50), 1)

def generate_tutoring_sessions(parental):
    if parental == "High":
        return random.randint(5, 15)
    elif parental == "Medium":
        return random.randint(2, 7)
    else:
        return random.randint(0, 3)

def generate_household_income(school_type):
    if school_type == "Private":
        return random.randint(70000, 160000)
    elif school_type == "Public":
        return random.randint(20000, 80000)
    else:
        return random.randint(25000, 60000)

def generate_distance_from_home():
    base = random.random()
    if base < 0.6:
        return round(random.uniform(0.5, 5), 2)
    elif base < 0.9:
        return round(random.uniform(5, 15), 2)
    else:
        return round(random.uniform(15, 30), 2)

# =========================
# PERFORMANCE MODEL
# =========================
def generate_student_grade(attendance, parental, tutoring, peer, ld_flag):
    score = 50

    score += (attendance - 75) * 0.4

    if parental == "High":
        score += 10
    elif parental == "Medium":
        score += 5

    score += tutoring * 0.8

    if peer == "Positive":
        score += 6
    elif peer == "Negative":
        score -= 6

    if ld_flag == "Y":
        score -= 8

    noise = random.uniform(-5, 5)
    score += noise

    return round(min(max(score, 0), 100), 1)

# =========================
# DATASET CREATION
# =========================
student_ids = set()
records = []

for _ in range(NUM_STUDENTS):
    student_id = generate_id(student_ids, ID_LEN)

    gender = generate_gender()
    school_type = generate_school_type()
    parental = generate_parental_involvement()
    peer = generate_peer_influence()
    ld_flag = generate_learning_disability()

    attendance = generate_attendance(ld_flag)
    tutoring = generate_tutoring_sessions(parental)
    income = generate_household_income(school_type)
    distance = generate_distance_from_home()

    grade = generate_student_grade(
        attendance,
        parental,
        tutoring,
        peer,
        ld_flag
    )

    records.append([
        student_id,
        gender,
        attendance,
        ld_flag,
        grade,
        parental,
        tutoring,
        income,
        school_type,
        distance,
        peer
    ])

columns = [
    "Student_ID",
    "Gender",
    "Attendance_Percentage",
    "Learning_Disability",
    "Final_Grade",
    "Parental_Involvement",
    "Tutoring_Sessions",
    "Household_Income",
    "School_Type",
    "Distance_From_Home_km",
    "Peer_Influence"
]

df = pd.DataFrame(records, columns=columns)

# =========================
# EXPORT
# =========================
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
filename = f"{OUTPUT_DIR}\\student_performance_dataset_{timestamp}.csv"
df.to_csv(filename, index=False)

print(f"Dataset generated: {filename}")
print(df.head())
