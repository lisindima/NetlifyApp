//
//  NotificationsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 20.05.2021.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    @AppStorage("notificationToken") private var notificationToken: String = ""
    @AppStorage("notificationsStatus") private var notificationsStatus: UNAuthorizationStatus = .notDetermined
    
    @State private var deploySucceeded: Bool = false
    @State private var succeededIdHook: String = ""
    @State private var deployFailed: Bool = false
    @State private var failedIdHook: String = ""
    @State private var formNotifications: Bool = false
    @State private var formIdHook: String = ""
    @State private var loading: Bool = true
    
    let siteId: String
    let forms: Forms?
    
    var body: some View {
        Form {
            if notificationsStatus == .authorized {
                Group {
                    Section(header: Text("section_header_deploy_notifications"), footer: Text("section_footer_deploy_notifications")) {
                        Toggle(isOn: $deploySucceeded) {
                            DeployState.ready
                        }
                        .onChange(of: deploySucceeded) { value in
                            if !loading {
                                async {
                                    if value {
                                        await createNotification(event: .deployCreated)
                                    } else {
                                        await sessionStore.deleteNotification(succeededIdHook)
                                    }
                                }
                            }
                        }
                        Toggle(isOn: $deployFailed) {
                            DeployState.error
                        }
                        .onChange(of: deployFailed) { value in
                            if !loading {
                                async {
                                    if value {
                                        await createNotification(event: .deployFailed)
                                    } else {
                                        await sessionStore.deleteNotification(failedIdHook)
                                    }
                                }
                            }
                        }
                    }
                    if forms != nil {
                        Section(header: Text("section_header_form_notifications")) {
                            Toggle(isOn: $formNotifications) {
                                Label("toggle_title_new_form_submission", systemImage: "envelope.fill")
                            }
                            .onChange(of: formNotifications) { value in
                                if !loading {
                                    async {
                                        if value {
                                            await createNotification(event: .submissionCreated)
                                        } else {
                                            await sessionStore.deleteNotification(formIdHook)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .disabled(loading)
                .redacted(reason: loading ? .placeholder : [])
            } else {
                Link("button_title_enable_notifications", destination: URL(string: UIApplication.openSettingsURLString)!)
                    .onAppear {
                        async {
                            sessionStore.enableNotification()
                        }
                    }
            }
        }
        .navigationTitle("button_title_notifications")
        .task {
            await loadingState()
        }
    }
    
    let loader = Loader()
    
    private func loadingState() async {
        do {
            let value: [Hook] = try await loader.fetch(.hooks(siteId: siteId))
            value.forEach { hook in
                if let data = hook.data["url"], let url = data {
                    if let url = URL(string: url), notificationToken == url["device_id"] {
                        if hook.event == .deployCreated, hook.type == "url" {
                            deploySucceeded = true
                            succeededIdHook = hook.id
                        } else if hook.event == .deployFailed, hook.type == "url" {
                            deployFailed = true
                            failedIdHook = hook.id
                        } else if hook.event == .submissionCreated, hook.type == "url" {
                            formNotifications = true
                            formIdHook = hook.id
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                loading = false
            }
        } catch {
            print("getHooks", error)
        }
    }
    
    private func createNotification(event: Event) async {
        do {
            let value: Hook = try await loader.upload(.hooks(siteId: siteId), parameters: parameters(event: event))
            if event == .deployCreated {
                succeededIdHook = value.id
            }
            if event == .deployFailed {
                failedIdHook = value.id
            }
            if event == .submissionCreated {
                formIdHook = value.id
            }
        } catch {
            print(error)
        }
    }
    
    private func parameters(
        event: Event
    ) -> Hook {
        Hook(
            id: "",
            siteId: siteId,
            formId: nil,
            formName: nil,
            userId: "",
            type: "url",
            event: event,
            data: [
                "url": "https://lisindmitriy.me/.netlify/functions/\(event.actor.rawValue)?device_id=\(notificationToken)",
            ],
            success: nil,
            createdAt: Date(),
            updatedAt: Date(),
            actor: event.actor,
            disabled: false,
            restricted: false
        )
    }
}
