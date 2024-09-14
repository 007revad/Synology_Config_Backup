# How to schedule a script in Synology Task Scheduler

To schedule a script to run on your Synology at boot-up or shutdown follow these steps:

**Note:** You can setup a schedule task and leave it disabled, so it only runs when you select the task in the Task Scheduler and click on the Run button.

1. Go to **Control Panel** > **Task Scheduler** > click **Create** > and select **Scheduled Task**.
2. Select **User-defined script**.
3. Enter a task name.
4. Leave **Enable** ticked.
5. Click **Schedule** and set a schedule.
6. Click **Task Settings**.
7. Optionally you can tick **Send run details by email** then enter your email address.
8. In the box under **User-defined script** type the path to the script. 
    - e.g. If you saved the script to a shared folder on volume1 called "scripts" you'd type: **/volume1/scripts/syno_cpu_temp.sh**
9. Click **OK** to save the settings.

Here's some screenshots showing what needs to be set:

<p align="leftr"><img src="images/schedule1.png"></p>

<p align="leftr"><img src="images/schedule2.png"></p>

<p align="leftr"><img src="images/schedule3.png"></p>

<p align="leftr"><img src="images/schedule4.png"></p>
