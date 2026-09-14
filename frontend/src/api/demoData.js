export const demoData = {
  patients: [
    { patient_id: 'PAT-01', first_name: 'Raman', last_name: 'Nathan', city: 'Chennai', state: 'TN', gender: 'Male', policy_no: 'POL-1001' },
    { patient_id: 'PAT-02', first_name: 'Kavitha', last_name: 'Subramanian', city: 'Chennai', state: 'TN', gender: 'Female', policy_no: 'POL-1002' },
    { patient_id: 'PAT-03', first_name: 'Arun', last_name: 'Prakash', city: 'Chennai', state: 'TN', gender: 'Male', policy_no: 'POL-1003' },
    { patient_id: 'PAT-04', first_name: 'Deepa', last_name: 'Balaji', city: 'Madurai', state: 'TN', gender: 'Female', policy_no: null },
    { patient_id: 'PAT-05', first_name: 'Karthik', last_name: 'Raja', city: 'Tambaram', state: 'TN', gender: 'Male', policy_no: 'POL-1004' },
    { patient_id: 'PAT-06', first_name: 'Sangeetha', last_name: 'Mani', city: 'Coimbatore', state: 'TN', gender: 'Female', policy_no: 'POL-1005' },
    { patient_id: 'PAT-07', first_name: 'Venkatesh', last_name: 'Ramanujam', city: 'Trichy', state: 'TN', gender: 'Male', policy_no: null },
    { patient_id: 'PAT-08', first_name: 'Ananya', last_name: 'Vasudevan', city: 'Chennai', state: 'TN', gender: 'Female', policy_no: 'POL-1006' },
  ],
  appointments: [
    { appointment_id: 'APT-01', patient_name: 'Raman Nathan', doctor_name: 'Sundaram Krishnan', department: 'Cardiology', appointment_date: '2026-09-10T00:00:00.000Z', appointment_time: '10:00 AM', status: 'Completed', consultation_mode: 'Virtual' },
    { appointment_id: 'APT-02', patient_name: 'Kavitha Subramanian', doctor_name: 'Meenakshi Sundaram', department: 'Neurology', appointment_date: '2026-09-12T00:00:00.000Z', appointment_time: '11:30 AM', status: 'Scheduled', consultation_mode: 'Virtual' },
    { appointment_id: 'APT-03', patient_name: 'Arun Prakash', doctor_name: 'Vikram Ramanathan', department: 'Orthopedics', appointment_date: '2026-09-15T00:00:00.000Z', appointment_time: '02:00 PM', status: 'Scheduled', consultation_mode: 'In-Person' },
    { appointment_id: 'APT-04', patient_name: 'Deepa Balaji', doctor_name: 'Rajesh Venkataraman', department: 'General Medicine', appointment_date: '2026-09-10T00:00:00.000Z', appointment_time: '09:00 AM', status: 'Completed', consultation_mode: 'In-Person' },
    { appointment_id: 'APT-05', patient_name: 'Karthik Raja', doctor_name: 'Rajesh Venkataraman', department: 'General Medicine', appointment_date: '2026-09-11T00:00:00.000Z', appointment_time: '04:00 PM', status: 'Scheduled', consultation_mode: 'Virtual' },
    { appointment_id: 'APT-06', patient_name: 'Sangeetha Mani', doctor_name: 'Priya Dharshini', department: 'Dermatology', appointment_date: '2026-09-13T00:00:00.000Z', appointment_time: '03:00 PM', status: 'Scheduled', consultation_mode: 'Virtual' },
    { appointment_id: 'APT-07', patient_name: 'Venkatesh Ramanujam', doctor_name: 'Kalyan Sundaram', department: 'Gastroenterology', appointment_date: '2026-09-14T00:00:00.000Z', appointment_time: '10:30 AM', status: 'Scheduled', consultation_mode: 'In-Person' },
    { appointment_id: 'APT-08', patient_name: 'Ananya Vasudevan', doctor_name: 'Shalini Narayanan', department: 'Pulmonology', appointment_date: '2026-09-16T00:00:00.000Z', appointment_time: '11:00 AM', status: 'Scheduled', consultation_mode: 'Virtual' },
  ],
  prescriptions: [],
  billing: [],
}
